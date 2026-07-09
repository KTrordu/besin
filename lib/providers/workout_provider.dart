import 'package:flutter/foundation.dart';
import '../models/exercise_log.dart';
import '../services/storage_service.dart';

/// Owns per-day exercise logs (sets/reps/weights) — orthogonal to the
/// nutrition state, persisted under its own key.
class WorkoutProvider extends ChangeNotifier {
  final StorageService _storage;

  WorkoutProvider({StorageService? storage})
      : _storage = storage ?? StorageService();

  Map<String, List<ExerciseEntry>> _logs = {};
  DateTime _selectedDate = _today();
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> init() async {
    await _storage.ensureInitialized();
    // Own growable copies — never mutate collections handed out by storage.
    final loaded = await _storage.loadExerciseLogs();
    _logs = {for (final e in loaded.entries) e.key: List.of(e.value)};
    _isLoading = false;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  List<ExerciseEntry> get currentEntries =>
      List.unmodifiable(_logs[_dateKey(_selectedDate)] ?? const []);

  List<ExerciseEntry> entriesFor(DateTime date) =>
      List.unmodifiable(_logs[_dateKey(date)] ?? const []);

  /// Distinct exercise names across all days, case-insensitively deduped,
  /// most recently used first. Feeds the add-exercise autocomplete.
  List<String> get knownExerciseNames {
    final byLower = <String, (DateTime, String)>{};
    for (final list in _logs.values) {
      for (final e in list) {
        final key = e.name.toLowerCase();
        final prev = byLower[key];
        if (prev == null || e.timestamp.isAfter(prev.$1)) {
          byLower[key] = (e.timestamp, e.name);
        }
      }
    }
    final entries = byLower.values.toList()
      ..sort((a, b) => b.$1.compareTo(a.$1));
    return entries.map((e) => e.$2).toList();
  }

  /// Chronological (date, entry) series for one exercise name — feeds the
  /// per-exercise progression charts.
  List<(DateTime, ExerciseEntry)> historyFor(String name) {
    final lower = name.toLowerCase();
    final result = <(DateTime, ExerciseEntry)>[];
    _logs.forEach((key, entries) {
      final date = DateTime.parse(key);
      for (final e in entries) {
        if (e.name.toLowerCase() == lower) result.add((date, e));
      }
    });
    result.sort((a, b) => a.$1.compareTo(b.$1));
    return result;
  }

  Future<void> addEntry(ExerciseEntry entry) async {
    final key = _dateKey(_selectedDate);
    _logs.putIfAbsent(key, () => []).add(entry);
    await _storage.saveExerciseLogs(_logs);
    notifyListeners();
  }

  Future<void> updateEntry(ExerciseEntry entry) async {
    final key = _dateKey(_selectedDate);
    final list = _logs[key];
    if (list == null) return;
    final idx = list.indexWhere((e) => e.id == entry.id);
    if (idx < 0) return;
    list[idx] = entry;
    await _storage.saveExerciseLogs(_logs);
    notifyListeners();
  }

  Future<void> deleteEntry(String entryId) async {
    final key = _dateKey(_selectedDate);
    final list = _logs[key];
    if (list == null) return;
    list.removeWhere((e) => e.id == entryId);
    if (list.isEmpty) _logs.remove(key);
    await _storage.saveExerciseLogs(_logs);
    notifyListeners();
  }

  Future<void> addSet(String entryId, ExerciseSet set) async {
    final key = _dateKey(_selectedDate);
    final list = _logs[key];
    if (list == null) return;
    final idx = list.indexWhere((e) => e.id == entryId);
    if (idx < 0) return;
    list[idx] = list[idx].copyWith(sets: [...list[idx].sets, set]);
    await _storage.saveExerciseLogs(_logs);
    notifyListeners();
  }

  Future<void> removeSet(String entryId, int setIndex) async {
    final key = _dateKey(_selectedDate);
    final list = _logs[key];
    if (list == null) return;
    final idx = list.indexWhere((e) => e.id == entryId);
    if (idx < 0) return;
    final sets = [...list[idx].sets];
    if (setIndex < 0 || setIndex >= sets.length) return;
    sets.removeAt(setIndex);
    list[idx] = list[idx].copyWith(sets: sets);
    await _storage.saveExerciseLogs(_logs);
    notifyListeners();
  }
}
