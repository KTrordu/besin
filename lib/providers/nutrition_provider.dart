import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/daily_log.dart';
import '../models/meal.dart';
import '../models/streak.dart';
import '../models/weight_log.dart';
import '../services/storage_service.dart';

class NutritionProvider extends ChangeNotifier {
  final StorageService _storage;

  NutritionProvider({StorageService? storage})
      : _storage = storage ?? StorageService();

  Map<String, DailyLog> _dailyLogs = {};
  List<WeightLog> _weightLogs = [];
  List<Meal> _favoriteMeals = [];
  DailyGoals _defaultGoals = DailyGoals.defaultGoals;
  StreakData _streakData = const StreakData();
  DateTime _selectedDate = _today();
  bool _isLoading = true;
  bool _enableWorkoutTracking = true;
  bool _trackProtein = true;
  bool _trackCarbs = true;
  bool _trackFat = true;
  List<String> _customNutrients = [];
  bool _streakRequireCalories = true;
  bool _streakRequireProtein = true;
  bool _streakRequireCarbs = false;
  bool _streakRequireFat = false;
  double _streakThreshold = 0.90;

  // ── Getters ───────────────────────────────────

  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;
  DailyGoals get defaultGoals => _defaultGoals;
  StreakData get streakData => _streakData;
  bool get enableWorkoutTracking => _enableWorkoutTracking;
  bool get trackProtein => _trackProtein;
  bool get trackCarbs => _trackCarbs;
  bool get trackFat => _trackFat;
  List<String> get customNutrients => List.unmodifiable(_customNutrients);
  bool get streakRequireCalories => _streakRequireCalories;
  bool get streakRequireProtein => _streakRequireProtein;
  bool get streakRequireCarbs => _streakRequireCarbs;
  bool get streakRequireFat => _streakRequireFat;
  double get streakThreshold => _streakThreshold;
  List<WeightLog> get weightLogs => List.unmodifiable(_weightLogs);
  List<Meal> get favoriteMeals => List.unmodifiable(_favoriteMeals);
  List<DailyLog> get allDailyLogs {
    final list = _dailyLogs.values.toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  DailyLog get currentDailyLog =>
      _dailyLogs[_dateKey(_selectedDate)] ??
      DailyLog(date: _selectedDate, meals: const [], goals: _defaultGoals);

  bool get todayGoalsMet {
    final todayKey = _dateKey(_today());
    final log = _dailyLogs[todayKey];
    return log != null && _isDaySuccessful(log);
  }

  // ── Init ──────────────────────────────────────

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> init() async {
    await _storage.ensureInitialized();
    _dailyLogs = await _storage.loadDailyLogs();
    _weightLogs = await _storage.loadWeightLogs();
    _defaultGoals = await _storage.loadDefaultGoals();
    _favoriteMeals = await _storage.loadFavoriteMeals();
    _streakData = await _storage.loadStreakData();
    _enableWorkoutTracking = await _storage.loadEnableWorkoutTracking();
    _trackProtein = await _storage.loadTrackProtein();
    _trackCarbs = await _storage.loadTrackCarbs();
    _trackFat = await _storage.loadTrackFat();
    _customNutrients = await _storage.loadCustomNutrients();
    _streakRequireCalories = await _storage.loadStreakRequireCalories();
    _streakRequireProtein = await _storage.loadStreakRequireProtein();
    _streakRequireCarbs = await _storage.loadStreakRequireCarbs();
    _streakRequireFat = await _storage.loadStreakRequireFat();
    _streakThreshold = await _storage.loadStreakThreshold();
    _recalculateStreak();
    _isLoading = false;
    notifyListeners();
  }

  // ── Date selection ────────────────────────────

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  // ── Meal CRUD ─────────────────────────────────

  Future<void> addMeal(Meal meal) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key] ??
        DailyLog(date: _selectedDate, meals: const [], goals: _defaultGoals);
    _dailyLogs[key] = log.copyWith(meals: [...log.meals, meal]);
    await _storage.saveDailyLogs(_dailyLogs);
    await _persistStreak();
    notifyListeners();
  }

  Future<void> updateMeal(Meal updated) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key];
    if (log == null) return;
    _dailyLogs[key] = log.copyWith(
      meals: log.meals.map((m) => m.id == updated.id ? updated : m).toList(),
    );
    await _storage.saveDailyLogs(_dailyLogs);
    await _persistStreak();
    notifyListeners();
  }

  Future<void> deleteMeal(String mealId) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key];
    if (log == null) return;
    _dailyLogs[key] =
        log.copyWith(meals: log.meals.where((m) => m.id != mealId).toList());
    await _storage.saveDailyLogs(_dailyLogs);
    await _persistStreak();
    notifyListeners();
  }

  // ── Goals & Weight ────────────────────────────

  Future<void> updateDefaultGoals(DailyGoals goals) async {
    _defaultGoals = goals;
    await _storage.saveDefaultGoals(goals);
    await _persistStreak();
    notifyListeners();
  }

  Future<void> setEnableWorkoutTracking(bool value) async {
    _enableWorkoutTracking = value;
    await _storage.saveEnableWorkoutTracking(value);
    notifyListeners();
  }

  Future<void> setTrackProtein(bool v) async {
    _trackProtein = v;
    await _storage.saveTrackProtein(v);
    notifyListeners();
  }

  Future<void> setTrackCarbs(bool v) async {
    _trackCarbs = v;
    await _storage.saveTrackCarbs(v);
    notifyListeners();
  }

  Future<void> setTrackFat(bool v) async {
    _trackFat = v;
    await _storage.saveTrackFat(v);
    notifyListeners();
  }

  Future<void> addCustomNutrient(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || _customNutrients.contains(trimmed)) return;
    _customNutrients = [..._customNutrients, trimmed];
    await _storage.saveCustomNutrients(_customNutrients);
    notifyListeners();
  }

  Future<void> removeCustomNutrient(String name) async {
    _customNutrients = _customNutrients.where((n) => n != name).toList();
    await _storage.saveCustomNutrients(_customNutrients);
    notifyListeners();
  }

  // ── Streak rules ──────────────────────────────

  Future<void> setStreakRequireCalories(bool v) async {
    _streakRequireCalories = v;
    await _storage.saveStreakRequireCalories(v);
    await _persistStreak();
    notifyListeners();
  }

  Future<void> setStreakRequireProtein(bool v) async {
    _streakRequireProtein = v;
    await _storage.saveStreakRequireProtein(v);
    await _persistStreak();
    notifyListeners();
  }

  Future<void> setStreakRequireCarbs(bool v) async {
    _streakRequireCarbs = v;
    await _storage.saveStreakRequireCarbs(v);
    await _persistStreak();
    notifyListeners();
  }

  Future<void> setStreakRequireFat(bool v) async {
    _streakRequireFat = v;
    await _storage.saveStreakRequireFat(v);
    await _persistStreak();
    notifyListeners();
  }

  Future<void> updateStreakThreshold(double value) async {
    _streakThreshold = value.clamp(0.50, 1.00);
    await _storage.saveStreakThreshold(_streakThreshold);
    await _persistStreak();
    notifyListeners();
  }

  // ── JSON backup / restore ─────────────────────

  Future<void> exportBackup() => _storage.exportDataAsJson();

  Future<void> importBackup(String jsonString) async {
    await _storage.importDataFromJson(jsonString);
    await init();
  }

  Future<void> addOrUpdateWeight(double weightKg) async {
    final todayKey = _dateKey(_today());
    final idx = _weightLogs.indexWhere((w) => _dateKey(w.date) == todayKey);
    final entry = WeightLog(date: _today(), weightKg: weightKg);
    if (idx >= 0) {
      _weightLogs[idx] = entry;
    } else {
      _weightLogs.add(entry);
    }
    _weightLogs.sort((a, b) => a.date.compareTo(b.date));
    await _storage.saveWeightLogs(_weightLogs);
    notifyListeners();
  }

  // ── Workout type ──────────────────────────────

  Future<void> updateWorkoutType(WorkoutType type) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key] ??
        DailyLog(date: _selectedDate, meals: const [], goals: _defaultGoals);
    _dailyLogs[key] = log.copyWith(workoutType: type);
    await _storage.saveDailyLogs(_dailyLogs);
    notifyListeners();
  }

  Future<void> addWater(int ml) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key] ??
        DailyLog(date: _selectedDate, meals: const [], goals: _defaultGoals);
    final newIntake = (log.waterIntake + ml).clamp(0, 10000);
    _dailyLogs[key] = log.copyWith(waterIntake: newIntake);
    await _storage.saveDailyLogs(_dailyLogs);
    notifyListeners();
  }

  Future<void> updateFlexibleMacroDay(bool isFlexible, String? macroRequired) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key] ??
        DailyLog(date: _selectedDate, meals: const [], goals: _defaultGoals);
    _dailyLogs[key] = log.copyWith(
      isFlexibleMacroDay: isFlexible,
      flexibleMacroRequired: isFlexible ? macroRequired : null,
    );
    await _storage.saveDailyLogs(_dailyLogs);
    await _persistStreak();
    notifyListeners();
  }

  Future<void> updateCheatDay(bool isCheat) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key] ??
        DailyLog(date: _selectedDate, meals: const [], goals: _defaultGoals);
    _dailyLogs[key] = log.copyWith(isCheatDay: isCheat);
    await _storage.saveDailyLogs(_dailyLogs);
    await _persistStreak();
    notifyListeners();
  }

  // Returns logs for the last [days] days grouped by workout type,
  // excluding days with WorkoutType.none or no meals.
  Map<WorkoutType, List<DailyLog>> getLogsByWorkoutType(int days) {
    final result = <WorkoutType, List<DailyLog>>{};
    for (final log in getRecentLogs(days)) {
      if (log.workoutType == WorkoutType.none || log.meals.isEmpty) continue;
      if (log.isCheatDay) continue;
      result.putIfAbsent(log.workoutType, () => []).add(log);
    }
    return result;
  }

  // ── Favorites ─────────────────────────────────

  Future<void> addToFavorites(Meal meal) async {
    final idx = _favoriteMeals.indexWhere(
      (m) => m.name.toLowerCase() == meal.name.toLowerCase(),
    );
    final entry = Meal(
      id: idx >= 0
          ? _favoriteMeals[idx].id
          : 'fav_${DateTime.now().millisecondsSinceEpoch}',
      name: meal.name,
      calories: meal.calories,
      protein: meal.protein,
      carbs: meal.carbs,
      fat: meal.fat,
      timestamp: DateTime.now(),
      mealType: meal.mealType,
      isFavorite: true,
    );
    if (idx >= 0) {
      _favoriteMeals[idx] = entry;
    } else {
      _favoriteMeals.add(entry);
    }
    await _storage.saveFavoriteMeals(_favoriteMeals);
    notifyListeners();
  }

  Future<void> removeFromFavorites(String mealId) async {
    _favoriteMeals.removeWhere((m) => m.id == mealId);
    await _storage.saveFavoriteMeals(_favoriteMeals);
    notifyListeners();
  }

  // ── Chart helpers ─────────────────────────────

  List<DailyLog> getRecentLogs(int days) {
    final now = _today();
    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: days - 1 - i));
      return _dailyLogs[_dateKey(date)] ??
          DailyLog(date: date, meals: const [], goals: _defaultGoals);
    });
  }

  /// Like [getRecentLogs] but omits cheat days entirely (no placeholder bar).
  List<DailyLog> getChartLogs(int days) =>
      getRecentLogs(days).where((log) => !log.isCheatDay).toList();

  // ── Streak logic ──────────────────────────────

  bool _isDaySuccessful(DailyLog log) {
    if (log.isCheatDay) return true;
    if (log.meals.isEmpty) return false;
    if (log.isFlexibleMacroDay) {
      final g = log.goals;
      final macro = log.flexibleMacroRequired ?? 'protein';
      if (macro == 'protein') return log.totalProtein >= g.protein * _streakThreshold;
      if (macro == 'carbs') return log.totalCarbs >= g.carbs * _streakThreshold;
      if (macro == 'fat') return log.totalFat >= g.fat * _streakThreshold;
      return true;
    }
    final g = log.goals;
    if (_streakRequireCalories && log.totalCalories < g.calories * _streakThreshold) {
      return false;
    }
    if (_streakRequireProtein && log.totalProtein < g.protein * _streakThreshold) {
      return false;
    }
    if (_streakRequireCarbs && log.totalCarbs < g.carbs * _streakThreshold) {
      return false;
    }
    if (_streakRequireFat && log.totalFat < g.fat * _streakThreshold) {
      return false;
    }
    return true;
  }

  void _recalculateStreak() {
    final today = _today();
    int streak = 0;

    // Today is "in progress": count it only if it's already successful.
    // A pending/empty today must never break a streak built on prior days.
    final todayLog = _dailyLogs[_dateKey(today)];
    if (todayLog != null && _isDaySuccessful(todayLog)) {
      streak = 1;
    }

    // Scan consecutive successful days backwards starting from yesterday.
    var checkDate = today.subtract(const Duration(days: 1));
    for (int i = 0; i < 365; i++) {
      final log = _dailyLogs[_dateKey(checkDate)];
      if (log == null || !_isDaySuccessful(log)) break;
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    _streakData = StreakData(
      currentStreak: streak,
      longestStreak: max(streak, _streakData.longestStreak),
    );
  }

  Future<void> _persistStreak() async {
    _recalculateStreak();
    await _storage.saveStreakData(_streakData);
  }
}
