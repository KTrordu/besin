import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_log.dart';
import '../models/meal.dart';
import '../models/streak.dart';
import '../models/weight_log.dart';

class StorageService {
  static const _dailyLogsKey = 'daily_logs';
  static const _weightLogsKey = 'weight_logs';
  static const _defaultGoalsKey = 'default_goals';
  static const _favoriteMealsKey = 'favorite_meals';
  static const _streakDataKey = 'streak_data';

  late SharedPreferences _prefs;

  /// Call once before any load/save to initialise the SharedPreferences
  /// singleton.  Safe to call multiple times (no-op after first call).
  Future<void> ensureInitialized() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Daily logs ────────────────────────────────

  Future<Map<String, DailyLog>> loadDailyLogs() async {
    final raw = _prefs.getString(_dailyLogsKey);
    if (raw == null) return {};
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map(
      (k, v) => MapEntry(k, DailyLog.fromJson(v as Map<String, dynamic>)),
    );
  }

  Future<void> saveDailyLogs(Map<String, DailyLog> logs) async {
    await _prefs.setString(
      _dailyLogsKey,
      jsonEncode(logs.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }

  // ── Weight logs ───────────────────────────────

  Future<List<WeightLog>> loadWeightLogs() async {
    final raw = _prefs.getString(_weightLogsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((w) => WeightLog.fromJson(w as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveWeightLogs(List<WeightLog> logs) async {
    await _prefs.setString(
      _weightLogsKey,
      jsonEncode(logs.map((w) => w.toJson()).toList()),
    );
  }

  // ── Default goals ─────────────────────────────

  Future<DailyGoals> loadDefaultGoals() async {
    final raw = _prefs.getString(_defaultGoalsKey);
    if (raw == null) return DailyGoals.defaultGoals;
    return DailyGoals.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveDefaultGoals(DailyGoals goals) async {
    await _prefs.setString(_defaultGoalsKey, jsonEncode(goals.toJson()));
  }

  // ── Favorite meals ────────────────────────────

  Future<List<Meal>> loadFavoriteMeals() async {
    final raw = _prefs.getString(_favoriteMealsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((m) => Meal.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFavoriteMeals(List<Meal> meals) async {
    await _prefs.setString(
      _favoriteMealsKey,
      jsonEncode(meals.map((m) => m.toJson()).toList()),
    );
  }

  // ── Streak data ───────────────────────────────

  Future<StreakData> loadStreakData() async {
    final raw = _prefs.getString(_streakDataKey);
    if (raw == null) return const StreakData();
    return StreakData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveStreakData(StreakData data) async {
    await _prefs.setString(_streakDataKey, jsonEncode(data.toJson()));
  }

  // ── App settings ──────────────────────────────

  static const _enableWorkoutTrackingKey = 'enable_workout_tracking';

  Future<bool> loadEnableWorkoutTracking() async =>
      _prefs.getBool(_enableWorkoutTrackingKey) ?? true;

  Future<void> saveEnableWorkoutTracking(bool value) async =>
      _prefs.setBool(_enableWorkoutTrackingKey, value);

  // ── Macro tracking ────────────────────────────

  static const _trackProteinKey = 'track_protein';
  static const _trackCarbsKey = 'track_carbs';
  static const _trackFatKey = 'track_fat';

  Future<bool> loadTrackProtein() async =>
      _prefs.getBool(_trackProteinKey) ?? true;
  Future<void> saveTrackProtein(bool v) async =>
      _prefs.setBool(_trackProteinKey, v);

  Future<bool> loadTrackCarbs() async =>
      _prefs.getBool(_trackCarbsKey) ?? true;
  Future<void> saveTrackCarbs(bool v) async =>
      _prefs.setBool(_trackCarbsKey, v);

  Future<bool> loadTrackFat() async =>
      _prefs.getBool(_trackFatKey) ?? true;
  Future<void> saveTrackFat(bool v) async =>
      _prefs.setBool(_trackFatKey, v);

  // ── Custom nutrients ──────────────────────────

  static const _customNutrientsKey = 'custom_nutrients';

  Future<List<String>> loadCustomNutrients() async {
    final raw = _prefs.getString(_customNutrientsKey);
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw) as List<dynamic>);
  }

  Future<void> saveCustomNutrients(List<String> nutrients) async =>
      _prefs.setString(_customNutrientsKey, jsonEncode(nutrients));

  // ── Streak rules ──────────────────────────────

  static const _streakRequireCaloriesKey = 'streak_require_calories';
  static const _streakRequireProteinKey = 'streak_require_protein';
  static const _streakRequireCarbsKey = 'streak_require_carbs';
  static const _streakRequireFatKey = 'streak_require_fat';

  Future<bool> loadStreakRequireCalories() async =>
      _prefs.getBool(_streakRequireCaloriesKey) ?? true;
  Future<void> saveStreakRequireCalories(bool v) async =>
      _prefs.setBool(_streakRequireCaloriesKey, v);

  Future<bool> loadStreakRequireProtein() async =>
      _prefs.getBool(_streakRequireProteinKey) ?? true;
  Future<void> saveStreakRequireProtein(bool v) async =>
      _prefs.setBool(_streakRequireProteinKey, v);

  Future<bool> loadStreakRequireCarbs() async =>
      _prefs.getBool(_streakRequireCarbsKey) ?? false;
  Future<void> saveStreakRequireCarbs(bool v) async =>
      _prefs.setBool(_streakRequireCarbsKey, v);

  Future<bool> loadStreakRequireFat() async =>
      _prefs.getBool(_streakRequireFatKey) ?? false;
  Future<void> saveStreakRequireFat(bool v) async =>
      _prefs.setBool(_streakRequireFatKey, v);

  // ── Streak threshold ──────────────────────────

  static const _streakThresholdKey = 'streak_threshold';

  Future<double> loadStreakThreshold() async =>
      _prefs.getDouble(_streakThresholdKey) ?? 0.90;
  Future<void> saveStreakThreshold(double v) async =>
      _prefs.setDouble(_streakThresholdKey, v);
}
