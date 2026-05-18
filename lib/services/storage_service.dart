import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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

  // ── JSON backup / restore ─────────────────────

  /// Collects all persisted data into a structured Map.
  /// Returns a plain-Dart object tree safe for JSON encoding.
  Map<String, dynamic> buildBackupMap() {
    dynamic parseKey(String key) {
      final raw = _prefs.getString(key);
      return raw != null ? jsonDecode(raw) : null;
    }

    return {
      'version': 1,
      'exportDate': DateTime.now().toIso8601String(),
      if (parseKey(_dailyLogsKey) != null)
        'dailyLogs': parseKey(_dailyLogsKey),
      if (parseKey(_weightLogsKey) != null)
        'weightLogs': parseKey(_weightLogsKey),
      if (parseKey(_defaultGoalsKey) != null)
        'defaultGoals': parseKey(_defaultGoalsKey),
      if (parseKey(_favoriteMealsKey) != null)
        'favoriteMeals': parseKey(_favoriteMealsKey),
      if (parseKey(_streakDataKey) != null)
        'streakData': parseKey(_streakDataKey),
      if (parseKey(_customNutrientsKey) != null)
        'customNutrients': parseKey(_customNutrientsKey),
      'enableWorkoutTracking':
          _prefs.getBool(_enableWorkoutTrackingKey) ?? true,
      'trackProtein': _prefs.getBool(_trackProteinKey) ?? true,
      'trackCarbs': _prefs.getBool(_trackCarbsKey) ?? true,
      'trackFat': _prefs.getBool(_trackFatKey) ?? true,
      'streakRequireCalories':
          _prefs.getBool(_streakRequireCaloriesKey) ?? true,
      'streakRequireProtein': _prefs.getBool(_streakRequireProteinKey) ?? true,
      'streakRequireCarbs': _prefs.getBool(_streakRequireCarbsKey) ?? false,
      'streakRequireFat': _prefs.getBool(_streakRequireFatKey) ?? false,
      'streakThreshold': _prefs.getDouble(_streakThresholdKey) ?? 0.90,
    };
  }

  /// Writes the contents of [data] (as produced by [buildBackupMap]) back into
  /// SharedPreferences, overwriting any existing values.
  Future<void> applyBackupMap(Map<String, dynamic> data) async {
    void writeStr(String key, String mapKey) {
      if (data.containsKey(mapKey)) {
        _prefs.setString(key, jsonEncode(data[mapKey]));
      }
    }

    void writeBool(String key, String mapKey) {
      if (data.containsKey(mapKey) && data[mapKey] is bool) {
        _prefs.setBool(key, data[mapKey] as bool);
      }
    }

    writeStr(_dailyLogsKey, 'dailyLogs');
    writeStr(_weightLogsKey, 'weightLogs');
    writeStr(_defaultGoalsKey, 'defaultGoals');
    writeStr(_favoriteMealsKey, 'favoriteMeals');
    writeStr(_streakDataKey, 'streakData');
    writeStr(_customNutrientsKey, 'customNutrients');
    writeBool(_enableWorkoutTrackingKey, 'enableWorkoutTracking');
    writeBool(_trackProteinKey, 'trackProtein');
    writeBool(_trackCarbsKey, 'trackCarbs');
    writeBool(_trackFatKey, 'trackFat');
    writeBool(_streakRequireCaloriesKey, 'streakRequireCalories');
    writeBool(_streakRequireProteinKey, 'streakRequireProtein');
    writeBool(_streakRequireCarbsKey, 'streakRequireCarbs');
    writeBool(_streakRequireFatKey, 'streakRequireFat');
    if (data.containsKey('streakThreshold') &&
        data['streakThreshold'] is num) {
      await _prefs.setDouble(
          _streakThresholdKey, (data['streakThreshold'] as num).toDouble());
    }
  }

  /// Parses [jsonString], validates the backup format, then applies it.
  /// Throws [FormatException] when the string is not valid JSON or lacks
  /// the required `version` field.
  Future<void> importDataFromJson(String jsonString) async {
    dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } catch (_) {
      throw const FormatException('invalid_json');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('not_an_object');
    }
    if (decoded['version'] is! int) {
      throw const FormatException('missing_version');
    }
    await applyBackupMap(decoded);
  }

  /// Serialises all data to a pretty-printed JSON file and opens the system
  /// share sheet so the user can save or send it.
  Future<void> exportDataAsJson() async {
    final data = buildBackupMap();
    final json = const JsonEncoder.withIndent('  ').convert(data);
    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final file = File('${dir.path}/besin_backup_$stamp.json');
    await file.writeAsString(json, encoding: utf8);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'Besin Backup',
    );
  }
}
