import 'package:flutter_test/flutter_test.dart';
import 'package:kalori_takip/models/daily_log.dart';
import 'package:kalori_takip/models/meal.dart';

// ── Helpers ──────────────────────────────────────

Meal _makeMeal({
  String id = 'meal_1',
  double calories = 0,
  double protein = 0,
  double carbs = 0,
  double fat = 0,
  Map<String, double> extraNutrients = const {},
}) =>
    Meal(
      id: id,
      name: 'Test',
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      timestamp: DateTime(2025, 1, 1, 12),
      mealType: MealType.lunch,
      extraNutrients: extraNutrients,
    );

const _goals = DailyGoals(
  calories: 2000,
  protein: 150,
  carbs: 250,
  fat: 65,
);

// ── Tests ─────────────────────────────────────────

void main() {
  group('DailyLog — JSON round-trip', () {
    test('preserves all fields through toJson / fromJson', () {
      final original = DailyLog(
        date: DateTime(2025, 5, 10),
        meals: [_makeMeal(id: 'm1', calories: 500, protein: 30)],
        goals: _goals,
        workoutType: WorkoutType.push,
        isCheatDay: true,
        waterIntake: 1500,
      );

      final decoded = DailyLog.fromJson(original.toJson());

      expect(decoded.date, original.date);
      expect(decoded.meals.length, 1);
      expect(decoded.meals.first.calories, 500);
      expect(decoded.meals.first.protein, 30);
      expect(decoded.goals.calories, 2000);
      expect(decoded.goals.protein, 150);
      expect(decoded.workoutType, WorkoutType.push);
      expect(decoded.isCheatDay, true);
      expect(decoded.waterIntake, 1500);
    });

    test('Meal.extraNutrients preserved through DailyLog round-trip', () {
      final meal = _makeMeal(extraNutrients: {'Lif': 5.5, 'Sodyum': 200.0});
      final log = DailyLog(
        date: DateTime(2025, 1, 1),
        meals: [meal],
        goals: _goals,
      );

      final decoded = DailyLog.fromJson(log.toJson());
      expect(decoded.meals.first.extraNutrients['Lif'], 5.5);
      expect(decoded.meals.first.extraNutrients['Sodyum'], 200.0);
    });
  });

  group('DailyLog — backward-compat fromJson (null-safety)', () {
    // Represents a record saved before isCheatDay, waterIntake, workoutType
    // and Meal.extraNutrients fields were introduced.
    final oldJson = <String, dynamic>{
      'date': '2024-01-15T00:00:00.000',
      'meals': [
        <String, dynamic>{
          'id': 'm1',
          'name': 'Yumurta',
          'calories': 300.0,
          'protein': 20.0,
          'carbs': 2.0,
          'fat': 10.0,
          'timestamp': '2024-01-15T08:00:00.000',
          'mealType': 0,
          // isFavorite, quantity, barcode, extraNutrients intentionally absent
        },
      ],
      'goals': <String, dynamic>{
        'calories': 2000.0,
        'protein': 150.0,
        'carbs': 250.0,
        'fat': 65.0,
      },
      // workoutType, isCheatDay, waterIntake intentionally absent
    };

    test('isCheatDay defaults to false', () {
      expect(DailyLog.fromJson(oldJson).isCheatDay, false);
    });

    test('waterIntake defaults to 0', () {
      expect(DailyLog.fromJson(oldJson).waterIntake, 0);
    });

    test('workoutType defaults to WorkoutType.none', () {
      expect(DailyLog.fromJson(oldJson).workoutType, WorkoutType.none);
    });

    test('Meal.extraNutrients defaults to empty map', () {
      expect(DailyLog.fromJson(oldJson).meals.first.extraNutrients, isEmpty);
    });

    test('Meal.isFavorite defaults to false', () {
      expect(DailyLog.fromJson(oldJson).meals.first.isFavorite, false);
    });

    test('Meal.quantity defaults to 1.0', () {
      expect(DailyLog.fromJson(oldJson).meals.first.quantity, 1.0);
    });
  });

  group('DailyLog — computed totals', () {
    test('totalCalories sums all meals', () {
      final log = DailyLog(
        date: DateTime(2025, 1, 1),
        meals: [
          _makeMeal(id: 'm1', calories: 300),
          _makeMeal(id: 'm2', calories: 500),
        ],
        goals: _goals,
      );
      expect(log.totalCalories, 800);
    });

    test('totalProtein sums all meals', () {
      final log = DailyLog(
        date: DateTime(2025, 1, 1),
        meals: [
          _makeMeal(id: 'm1', protein: 40),
          _makeMeal(id: 'm2', protein: 60),
        ],
        goals: _goals,
      );
      expect(log.totalProtein, 100);
    });

    test('totalCarbs and totalFat sum correctly', () {
      final log = DailyLog(
        date: DateTime(2025, 1, 1),
        meals: [
          _makeMeal(id: 'm1', carbs: 80, fat: 20),
          _makeMeal(id: 'm2', carbs: 120, fat: 15),
        ],
        goals: _goals,
      );
      expect(log.totalCarbs, 200);
      expect(log.totalFat, 35);
    });

    test('totals are 0 when meals list is empty', () {
      final log = DailyLog(
        date: DateTime(2025, 1, 1),
        meals: const [],
        goals: _goals,
      );
      expect(log.totalCalories, 0);
      expect(log.totalProtein, 0);
    });

    test('totalExtraNutrients aggregates same keys across meals', () {
      final log = DailyLog(
        date: DateTime(2025, 1, 1),
        meals: [
          _makeMeal(id: 'm1', extraNutrients: {'Lif': 5.0, 'Sodyum': 200.0}),
          _makeMeal(id: 'm2', extraNutrients: {'Lif': 3.0}),
        ],
        goals: _goals,
      );
      final totals = log.totalExtraNutrients;
      expect(totals['Lif'], 8.0);
      expect(totals['Sodyum'], 200.0);
    });

    test('totalExtraNutrients is empty when no meals have extra nutrients', () {
      final log = DailyLog(
        date: DateTime(2025, 1, 1),
        meals: [_makeMeal()],
        goals: _goals,
      );
      expect(log.totalExtraNutrients, isEmpty);
    });
  });
}
