import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_log.dart';
import '../models/weight_log.dart';

class StorageService {
  static const _dailyLogsKey = 'daily_logs';
  static const _weightLogsKey = 'weight_logs';
  static const _defaultGoalsKey = 'default_goals';

  Future<Map<String, DailyLog>> loadDailyLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dailyLogsKey);
    if (raw == null) return {};
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map(
      (k, v) => MapEntry(k, DailyLog.fromJson(v as Map<String, dynamic>)),
    );
  }

  Future<void> saveDailyLogs(Map<String, DailyLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _dailyLogsKey,
      jsonEncode(logs.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }

  Future<List<WeightLog>> loadWeightLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_weightLogsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((w) => WeightLog.fromJson(w as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveWeightLogs(List<WeightLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _weightLogsKey,
      jsonEncode(logs.map((w) => w.toJson()).toList()),
    );
  }

  Future<DailyGoals> loadDefaultGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_defaultGoalsKey);
    if (raw == null) return DailyGoals.defaultGoals;
    return DailyGoals.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveDefaultGoals(DailyGoals goals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultGoalsKey, jsonEncode(goals.toJson()));
  }
}
