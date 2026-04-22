import 'package:flutter/foundation.dart';
import '../models/daily_log.dart';
import '../models/meal.dart';
import '../models/weight_log.dart';
import '../services/storage_service.dart';

class NutritionProvider extends ChangeNotifier {
  final _storage = StorageService();

  Map<String, DailyLog> _dailyLogs = {};
  List<WeightLog> _weightLogs = [];
  DailyGoals _defaultGoals = DailyGoals.defaultGoals;
  DateTime _selectedDate = _today();
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;
  DailyGoals get defaultGoals => _defaultGoals;
  List<WeightLog> get weightLogs => List.unmodifiable(_weightLogs);

  DailyLog get currentDailyLog =>
      _dailyLogs[_dateKey(_selectedDate)] ??
      DailyLog(date: _selectedDate, meals: const [], goals: _defaultGoals);

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> init() async {
    _dailyLogs = await _storage.loadDailyLogs();
    _weightLogs = await _storage.loadWeightLogs();
    _defaultGoals = await _storage.loadDefaultGoals();
    _isLoading = false;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  Future<void> addMeal(Meal meal) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key] ??
        DailyLog(date: _selectedDate, meals: const [], goals: _defaultGoals);
    _dailyLogs[key] = log.copyWith(meals: [...log.meals, meal]);
    await _storage.saveDailyLogs(_dailyLogs);
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
    notifyListeners();
  }

  Future<void> deleteMeal(String mealId) async {
    final key = _dateKey(_selectedDate);
    final log = _dailyLogs[key];
    if (log == null) return;
    _dailyLogs[key] =
        log.copyWith(meals: log.meals.where((m) => m.id != mealId).toList());
    await _storage.saveDailyLogs(_dailyLogs);
    notifyListeners();
  }

  Future<void> updateDefaultGoals(DailyGoals goals) async {
    _defaultGoals = goals;
    await _storage.saveDefaultGoals(goals);
    notifyListeners();
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

  List<DailyLog> getRecentLogs(int days) {
    final now = _today();
    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: days - 1 - i));
      return _dailyLogs[_dateKey(date)] ??
          DailyLog(date: date, meals: const [], goals: _defaultGoals);
    });
  }
}
