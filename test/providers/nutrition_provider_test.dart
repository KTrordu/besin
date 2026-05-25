import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kalori_takip/models/daily_log.dart';
import 'package:kalori_takip/models/meal.dart';
import 'package:kalori_takip/models/streak.dart';
import 'package:kalori_takip/providers/nutrition_provider.dart';
import 'package:kalori_takip/services/storage_service.dart';

// ── Mock ─────────────────────────────────────────

class MockStorageService extends Mock implements StorageService {}

// ── Helpers ──────────────────────────────────────

int _mealIdCounter = 0;

Meal _meal({
  double calories = 0,
  double protein = 0,
  double carbs = 0,
  double fat = 0,
}) =>
    Meal(
      id: 'test_${_mealIdCounter++}',
      name: 'Test',
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      timestamp: DateTime.now(),
      mealType: MealType.lunch,
    );

/// Stubs all [StorageService] reads that [NutritionProvider.init] calls,
/// plus the common writes triggered by addMeal / addWater / updateCheatDay.
void _stubStorage(
  MockStorageService s, {
  DailyGoals? goals,
  bool streakRequireCalories = true,
  bool streakRequireProtein = true,
  bool streakRequireCarbs = false,
  bool streakRequireFat = false,
  double streakThreshold = 0.90,
}) {
  // ── init ──
  when(() => s.ensureInitialized()).thenAnswer((_) async {});
  // ── reads ──
  when(() => s.loadDailyLogs()).thenAnswer((_) async => {});
  when(() => s.loadWeightLogs()).thenAnswer((_) async => []);
  when(() => s.loadDefaultGoals())
      .thenAnswer((_) async => goals ?? DailyGoals.defaultGoals);
  when(() => s.loadFavoriteMeals()).thenAnswer((_) async => []);
  when(() => s.loadStreakData()).thenAnswer((_) async => const StreakData());
  when(() => s.loadEnableWorkoutTracking()).thenAnswer((_) async => true);
  when(() => s.loadTrackProtein()).thenAnswer((_) async => true);
  when(() => s.loadTrackCarbs()).thenAnswer((_) async => true);
  when(() => s.loadTrackFat()).thenAnswer((_) async => true);
  when(() => s.loadCustomNutrients()).thenAnswer((_) async => []);
  when(() => s.loadStreakRequireCalories())
      .thenAnswer((_) async => streakRequireCalories);
  when(() => s.loadStreakRequireProtein())
      .thenAnswer((_) async => streakRequireProtein);
  when(() => s.loadStreakRequireCarbs())
      .thenAnswer((_) async => streakRequireCarbs);
  when(() => s.loadStreakRequireFat())
      .thenAnswer((_) async => streakRequireFat);
  when(() => s.loadStreakThreshold())
      .thenAnswer((_) async => streakThreshold);
  // ── writes ──
  when(() => s.saveDailyLogs(any())).thenAnswer((_) async {});
  when(() => s.saveStreakData(any())).thenAnswer((_) async {});
}

// ── Tests ─────────────────────────────────────────

void main() {
  // Register fallback values for custom argument types used with any()
  setUpAll(() {
    registerFallbackValue(<String, DailyLog>{});
    registerFallbackValue(const StreakData());
  });

  // ── addWater ──────────────────────────────────

  group('NutritionProvider — addWater', () {
    late MockStorageService mock;
    late NutritionProvider provider;

    setUp(() async {
      mock = MockStorageService();
      _stubStorage(mock);
      provider = NutritionProvider(storage: mock);
      await provider.init();
    });

    test('adds water to empty day', () async {
      await provider.addWater(500);
      expect(provider.currentDailyLog.waterIntake, 500);
    });

    test('accumulates across multiple calls', () async {
      await provider.addWater(1000);
      await provider.addWater(500);
      expect(provider.currentDailyLog.waterIntake, 1500);
    });

    test('negative amount from zero clamps to 0', () async {
      await provider.addWater(-500);
      expect(provider.currentDailyLog.waterIntake, 0);
    });

    test('negative amount from non-zero clamps to 0', () async {
      await provider.addWater(300);
      await provider.addWater(-1000);
      expect(provider.currentDailyLog.waterIntake, 0);
    });

    test('single large addition clamps to 10000', () async {
      await provider.addWater(15000);
      expect(provider.currentDailyLog.waterIntake, 10000);
    });

    test('accumulated total clamps to 10000', () async {
      await provider.addWater(8000);
      await provider.addWater(5000);
      expect(provider.currentDailyLog.waterIntake, 10000);
    });
  });

  // ── Streak: 90% threshold ─────────────────────

  group('NutritionProvider — streak (90% threshold, calories + protein required)', () {
    // 90% of 2600 = 2340 kcal, 90% of 150 = 135 g protein
    const goals = DailyGoals(calories: 2600, protein: 150, carbs: 250, fat: 65);

    late MockStorageService mock;
    late NutritionProvider provider;

    setUp(() async {
      mock = MockStorageService();
      _stubStorage(mock, goals: goals); // calories=true, protein=true by default
      provider = NutritionProvider(storage: mock);
      await provider.init();
    });

    test('exactly 90% of both calories and protein → success', () async {
      await provider.addMeal(_meal(calories: 2340, protein: 135));
      expect(provider.todayGoalsMet, true);
    });

    test('above 90% of both metrics → success', () async {
      await provider.addMeal(_meal(calories: 2500, protein: 145));
      expect(provider.todayGoalsMet, true);
    });

    test('1 kcal below 90% of calorie goal → failure', () async {
      // 2339 < 2340.0 threshold
      await provider.addMeal(_meal(calories: 2339, protein: 135));
      expect(provider.todayGoalsMet, false);
    });

    test('1 g below 90% of protein goal → failure', () async {
      // 134 < 135.0 threshold
      await provider.addMeal(_meal(calories: 2340, protein: 134));
      expect(provider.todayGoalsMet, false);
    });

    test('no meals logged → failure', () async {
      // No log entry exists yet
      expect(provider.todayGoalsMet, false);
    });
  });

  // ── Streak: only protein required ────────────

  group('NutritionProvider — streak (only protein required)', () {
    const goals = DailyGoals(calories: 2600, protein: 150, carbs: 250, fat: 65);

    late MockStorageService mock;
    late NutritionProvider provider;

    setUp(() async {
      mock = MockStorageService();
      _stubStorage(
        mock,
        goals: goals,
        streakRequireCalories: false,
        streakRequireProtein: true,
        streakRequireCarbs: false,
        streakRequireFat: false,
      );
      provider = NutritionProvider(storage: mock);
      await provider.init();
    });

    test('protein met but calories far below target → success', () async {
      // Calories are only 1000 (well below 2340 threshold), but calories not required
      await provider.addMeal(_meal(calories: 1000, protein: 140));
      expect(provider.todayGoalsMet, true);
    });

    test('protein exactly at 90% → success', () async {
      await provider.addMeal(_meal(calories: 500, protein: 135));
      expect(provider.todayGoalsMet, true);
    });

    test('protein deficient even when calories are perfect → failure', () async {
      await provider.addMeal(_meal(calories: 2600, protein: 100));
      expect(provider.todayGoalsMet, false);
    });
  });

  // ── Streak: cheat day ─────────────────────────

  group('NutritionProvider — cheat day', () {
    late MockStorageService mock;
    late NutritionProvider provider;

    setUp(() async {
      mock = MockStorageService();
      _stubStorage(mock);
      provider = NutritionProvider(storage: mock);
      await provider.init();
    });

    test('cheat day with no meals → streak protected', () async {
      await provider.updateCheatDay(true);
      expect(provider.todayGoalsMet, true);
    });

    test('cheat day with zero-macro meal → streak protected', () async {
      await provider.updateCheatDay(true);
      await provider.addMeal(_meal(calories: 0, protein: 0));
      expect(provider.todayGoalsMet, true);
    });

    test('cheat day with meals that would normally fail → streak protected', () async {
      // Default goals: 2000 kcal, 150g protein; this meal is far below
      await provider.updateCheatDay(true);
      await provider.addMeal(_meal(calories: 100, protein: 5));
      expect(provider.todayGoalsMet, true);
    });

    test('regular day with no meals → not protected', () async {
      // No log entry → todayGoalsMet is false
      expect(provider.todayGoalsMet, false);
    });

    test('regular day with insufficient intake → not protected', () async {
      // Default goals require ≥90% of 2000 kcal=1800 and 150g protein=135
      await provider.addMeal(_meal(calories: 500, protein: 50));
      expect(provider.todayGoalsMet, false);
    });
  });

  // ── Streak: custom threshold (80%) ───────────

  group('NutritionProvider — streak (custom 80% threshold)', () {
    // Goals: calories=2000, protein=150
    // 85% of goals: 1700 kcal, 127.5g → use 127g protein
    // At 80% threshold: need ≥1600 kcal & ≥120g protein → PASSES
    // At 90% threshold: need ≥1800 kcal & ≥135g protein → FAILS (contrast)
    const goals = DailyGoals(calories: 2000, protein: 150, carbs: 250, fat: 65);

    late MockStorageService mock;
    late NutritionProvider provider;

    setUp(() async {
      mock = MockStorageService();
      _stubStorage(mock, goals: goals, streakThreshold: 0.80);
      provider = NutritionProvider(storage: mock);
      await provider.init();
    });

    test('threshold loaded correctly from storage', () {
      expect(provider.streakThreshold, 0.80);
    });

    test('85% of goals passes at 80% threshold', () async {
      // 80% of 2000 = 1600 → 1700 ≥ 1600 ✓
      // 80% of 150  = 120  → 127 ≥ 120  ✓
      await provider.addMeal(_meal(calories: 1700, protein: 127));
      expect(provider.todayGoalsMet, true);
    });

    test('same 85% intake fails at 90% threshold (contrast test)', () async {
      // Verify the contrast using a fresh 90%-threshold provider
      final mock90 = MockStorageService();
      _stubStorage(mock90, goals: goals, streakThreshold: 0.90);
      final provider90 = NutritionProvider(storage: mock90);
      await provider90.init();

      // 90% of 2000 = 1800 → 1700 < 1800 → fails
      await provider90.addMeal(_meal(calories: 1700, protein: 127));
      expect(provider90.todayGoalsMet, false);
    });

    test('exactly at 80% boundary passes', () async {
      // 80% of 2000 = 1600 kcal, 80% of 150 = 120g protein
      await provider.addMeal(_meal(calories: 1600, protein: 120));
      expect(provider.todayGoalsMet, true);
    });

    test('1 unit below 80% boundary fails', () async {
      // 1599 < 1600 → fails on calories
      await provider.addMeal(_meal(calories: 1599, protein: 120));
      expect(provider.todayGoalsMet, false);
    });
  });

  // ── Streak: new-day tolerance ─────────────────

  group('NutritionProvider — streak new-day tolerance', () {
    test('yesterday met goals, today empty → streak preserved at 1', () async {
      const goals = DailyGoals(calories: 2000, protein: 150, carbs: 250, fat: 65);

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yKey = '${yesterday.year}-'
          '${yesterday.month.toString().padLeft(2, '0')}-'
          '${yesterday.day.toString().padLeft(2, '0')}';

      final yesterdayLog = DailyLog(
        date: yesterday,
        // 90% of 2000=1800 ✓, 90% of 150=135 ✓ → successful day
        meals: [_meal(calories: 1800, protein: 135)],
        goals: goals,
      );

      final mock = MockStorageService();
      _stubStorage(mock, goals: goals);
      when(() => mock.loadDailyLogs())
          .thenAnswer((_) async => {yKey: yesterdayLog});

      final provider = NutritionProvider(storage: mock);
      await provider.init();

      // Today has no data yet — should NOT be counted as goal met
      expect(provider.todayGoalsMet, false);
      // But yesterday's streak must be preserved
      expect(provider.streakData.currentStreak, 1);
    });

    test('two consecutive days met, today empty → streak is 2', () async {
      const goals = DailyGoals(calories: 2000, protein: 150, carbs: 250, fat: 65);

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final dayBefore = DateTime.now().subtract(const Duration(days: 2));

      String dateKey(DateTime d) =>
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

      final logs = {
        dateKey(dayBefore): DailyLog(
          date: dayBefore,
          meals: [_meal(calories: 1900, protein: 140)],
          goals: goals,
        ),
        dateKey(yesterday): DailyLog(
          date: yesterday,
          meals: [_meal(calories: 1850, protein: 136)],
          goals: goals,
        ),
      };

      final mock = MockStorageService();
      _stubStorage(mock, goals: goals);
      when(() => mock.loadDailyLogs()).thenAnswer((_) async => logs);

      final provider = NutritionProvider(storage: mock);
      await provider.init();

      expect(provider.streakData.currentStreak, 2);
    });

    test('yesterday missed goals, today empty → streak is 0', () async {
      const goals = DailyGoals(calories: 2000, protein: 150, carbs: 250, fat: 65);

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yKey = '${yesterday.year}-'
          '${yesterday.month.toString().padLeft(2, '0')}-'
          '${yesterday.day.toString().padLeft(2, '0')}';

      final yesterdayLog = DailyLog(
        date: yesterday,
        // Only 500 kcal — well below 90% threshold
        meals: [_meal(calories: 500, protein: 40)],
        goals: goals,
      );

      final mock = MockStorageService();
      _stubStorage(mock, goals: goals);
      when(() => mock.loadDailyLogs())
          .thenAnswer((_) async => {yKey: yesterdayLog});

      final provider = NutritionProvider(storage: mock);
      await provider.init();

      expect(provider.streakData.currentStreak, 0);
    });
  });

  // ── Streak: flexible macro day ────────────────

  group('NutritionProvider — flexible macro day', () {
    // Goals: calories=2000, protein=150, carbs=250, fat=65
    // 90% thresholds: 1800 kcal | 135g protein | 225g carbs | 58.5g fat
    const goals = DailyGoals(calories: 2000, protein: 150, carbs: 250, fat: 65);

    late MockStorageService mock;
    late NutritionProvider provider;

    setUp(() async {
      mock = MockStorageService();
      _stubStorage(mock, goals: goals); // calories + protein required by default
      provider = NutritionProvider(storage: mock);
      await provider.init();
    });

    test('flexible protein day — protein met, calories far below → success', () async {
      await provider.updateFlexibleMacroDay(true, 'protein');
      // 500 kcal is well below 90% calorie threshold (1800), but calories ignored
      await provider.addMeal(_meal(calories: 500, protein: 140));
      expect(provider.todayGoalsMet, true);
    });

    test('flexible protein day — protein below 90% → failure', () async {
      await provider.updateFlexibleMacroDay(true, 'protein');
      // 134 < 135 (90% of 150)
      await provider.addMeal(_meal(calories: 2000, protein: 134));
      expect(provider.todayGoalsMet, false);
    });

    test('flexible carbs day — carbs met, other macros ignored → success', () async {
      await provider.updateFlexibleMacroDay(true, 'carbs');
      // protein and calories far below goal, but only carbs matter
      await provider.addMeal(_meal(calories: 800, protein: 40, carbs: 230));
      expect(provider.todayGoalsMet, true);
    });

    test('flexible fat day — fat exactly at 90% → success', () async {
      await provider.updateFlexibleMacroDay(true, 'fat');
      // 90% of 65 = 58.5
      await provider.addMeal(_meal(calories: 500, protein: 30, fat: 58.5));
      expect(provider.todayGoalsMet, true);
    });

    test('flexible fat day — fat just below 90% → failure', () async {
      await provider.updateFlexibleMacroDay(true, 'fat');
      // 58.4 < 58.5
      await provider.addMeal(_meal(calories: 2000, protein: 150, fat: 58.4));
      expect(provider.todayGoalsMet, false);
    });

    test('disabling flexible mode reverts to normal streak rules', () async {
      await provider.updateFlexibleMacroDay(true, 'protein');
      await provider.updateFlexibleMacroDay(false, null);
      // Normal rules: calories + protein required; only 500 kcal → fails
      await provider.addMeal(_meal(calories: 500, protein: 140));
      expect(provider.todayGoalsMet, false);
    });

    test('flexible day with no meals → failure (empty day guard)', () async {
      await provider.updateFlexibleMacroDay(true, 'protein');
      expect(provider.todayGoalsMet, false);
    });
  });
}
