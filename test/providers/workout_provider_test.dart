import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kalori_takip/models/exercise_log.dart';
import 'package:kalori_takip/providers/workout_provider.dart';
import 'package:kalori_takip/services/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

void _stubStorage(
  MockStorageService s, {
  Map<String, List<ExerciseEntry>> logs = const {},
  List<SavedExercise> savedExercises = const [],
}) {
  when(() => s.ensureInitialized()).thenAnswer((_) async {});
  when(() => s.loadExerciseLogs()).thenAnswer(
      (_) async => {for (final e in logs.entries) e.key: List.of(e.value)});
  when(() => s.saveExerciseLogs(any())).thenAnswer((_) async {});
  when(() => s.loadSavedExercises())
      .thenAnswer((_) async => List.of(savedExercises));
  when(() => s.saveSavedExercises(any())).thenAnswer((_) async {});
}

ExerciseEntry entry(String id, String name, DateTime ts,
        {List<ExerciseSet> sets = const [ExerciseSet(reps: 8, weightKg: 50)]}) =>
    ExerciseEntry(id: id, name: name, sets: sets, timestamp: ts);

void main() {
  setUpAll(() {
    registerFallbackValue(<String, List<ExerciseEntry>>{});
    registerFallbackValue(<SavedExercise>[]);
  });

  group('WorkoutProvider — knownExerciseNames', () {
    test('dedupes case-insensitively keeping the most recent spelling',
        () async {
      final s = MockStorageService();
      _stubStorage(s, logs: {
        '2026-07-01': [entry('a', 'squat', DateTime(2026, 7, 1))],
        '2026-07-05': [
          entry('b', 'Squat', DateTime(2026, 7, 5)),
          entry('c', 'Bench Press', DateTime(2026, 7, 5, 11)),
        ],
      });
      final p = WorkoutProvider(storage: s);
      await p.init();

      expect(p.knownExerciseNames, ['Bench Press', 'Squat']);
    });
  });

  group('WorkoutProvider — historyFor', () {
    test('returns chronological matches for one exercise', () async {
      final s = MockStorageService();
      _stubStorage(s, logs: {
        '2026-07-05': [
          entry('b', 'SQUAT', DateTime(2026, 7, 5),
              sets: const [ExerciseSet(reps: 5, weightKg: 80)]),
        ],
        '2026-07-01': [
          entry('a', 'Squat', DateTime(2026, 7, 1)),
          entry('x', 'Deadlift', DateTime(2026, 7, 1)),
        ],
      });
      final p = WorkoutProvider(storage: s);
      await p.init();

      final history = p.historyFor('squat');
      expect(history, hasLength(2));
      expect(history[0].$1, DateTime(2026, 7, 1));
      expect(history[1].$1, DateTime(2026, 7, 5));
      expect(history[1].$2.maxWeight, 80);
    });
  });

  group('WorkoutProvider — entry CRUD', () {
    test('addEntry stores under the selected date and persists', () async {
      final s = MockStorageService();
      _stubStorage(s);
      final p = WorkoutProvider(storage: s);
      await p.init();
      p.selectDate(DateTime(2026, 7, 9));

      await p.addEntry(entry('a', 'Squat', DateTime(2026, 7, 9, 10)));
      expect(p.currentEntries, hasLength(1));
      expect(p.entriesFor(DateTime(2026, 7, 9)), hasLength(1));
      verify(() => s.saveExerciseLogs(any())).called(1);
    });

    test('deleteEntry removes the date key when it becomes empty', () async {
      final s = MockStorageService();
      _stubStorage(s, logs: {
        '2026-07-09': [entry('a', 'Squat', DateTime(2026, 7, 9, 10))],
      });
      final p = WorkoutProvider(storage: s);
      await p.init();
      p.selectDate(DateTime(2026, 7, 9));

      await p.deleteEntry('a');
      expect(p.currentEntries, isEmpty);
      final saved = verify(() => s.saveExerciseLogs(captureAny()))
          .captured
          .single as Map<String, List<ExerciseEntry>>;
      expect(saved.containsKey('2026-07-09'), false);
    });

    test('saved exercises: add overwrites same name, delete and log work',
        () async {
      final s = MockStorageService();
      _stubStorage(s);
      final p = WorkoutProvider(storage: s);
      await p.init();
      p.selectDate(DateTime(2026, 7, 9));

      await p.addSavedExercise(SavedExercise(
        id: 'sx1',
        name: 'Squat',
        sets: const [ExerciseSet(reps: 5, weightKg: 80)],
        createdAt: DateTime(2026, 7, 1),
      ));
      expect(p.isExerciseSaved('squat'), true);

      // Same name (different case) replaces instead of duplicating.
      await p.addSavedExercise(SavedExercise(
        id: 'sx2',
        name: 'SQUAT',
        sets: const [ExerciseSet(reps: 3, weightKg: 100)],
        createdAt: DateTime(2026, 7, 2),
      ));
      expect(p.savedExercises, hasLength(1));
      expect(p.savedExercises.single.id, 'sx2');

      // Logging from the template adds an entry for the selected day.
      await p.addEntryFromSaved(p.savedExercises.single);
      expect(p.currentEntries.single.name, 'SQUAT');
      expect(p.currentEntries.single.maxWeight, 100);

      await p.deleteSavedExerciseByName('squat');
      expect(p.savedExercises, isEmpty);
      expect(p.isExerciseSaved('Squat'), false);
    });

    test('saved exercises survive JSON round-trip', () {
      final ex = SavedExercise(
        id: 'sx1',
        name: 'Bench Press',
        sets: const [
          ExerciseSet(reps: 8, weightKg: 60),
          ExerciseSet(reps: 6, weightKg: 70),
        ],
        createdAt: DateTime(2026, 7, 1, 10, 30),
      );
      final restored = SavedExercise.fromJson(ex.toJson());
      expect(restored.id, ex.id);
      expect(restored.name, ex.name);
      expect(restored.sets, hasLength(2));
      expect(restored.sets[1].weightKg, 70);
      expect(restored.createdAt, ex.createdAt);
    });

    test('addSet and removeSet update the entry in place', () async {
      final s = MockStorageService();
      _stubStorage(s, logs: {
        '2026-07-09': [entry('a', 'Squat', DateTime(2026, 7, 9, 10))],
      });
      final p = WorkoutProvider(storage: s);
      await p.init();
      p.selectDate(DateTime(2026, 7, 9));

      await p.addSet('a', const ExerciseSet(reps: 6, weightKg: 60));
      expect(p.currentEntries.single.sets, hasLength(2));
      expect(p.currentEntries.single.maxWeight, 60);

      await p.removeSet('a', 0);
      expect(p.currentEntries.single.sets, hasLength(1));
      expect(p.currentEntries.single.sets.single.weightKg, 60);
    });
  });
}
