import 'package:flutter_test/flutter_test.dart';
import 'package:kalori_takip/models/exercise_log.dart';

void main() {
  ExerciseEntry buildEntry() => ExerciseEntry(
        id: 'ex1',
        name: 'Squat',
        sets: const [
          ExerciseSet(reps: 8, weightKg: 60),
          ExerciseSet(reps: 6, weightKg: 70),
          ExerciseSet(reps: 4, weightKg: 80),
        ],
        timestamp: DateTime(2026, 7, 1, 10, 30),
      );

  group('ExerciseEntry — derived stats', () {
    test('totalVolume is Σ reps × weight', () {
      expect(buildEntry().totalVolume,
          closeTo(8 * 60 + 6 * 70 + 4 * 80, 0.001));
    });

    test('maxWeight is the heaviest set', () {
      expect(buildEntry().maxWeight, 80);
    });

    test('empty sets yield zero stats', () {
      final e = ExerciseEntry(
        id: 'ex2',
        name: 'Plank',
        sets: const [],
        timestamp: DateTime(2026, 7, 1),
      );
      expect(e.totalVolume, 0);
      expect(e.maxWeight, 0);
    });
  });

  group('ExerciseEntry — JSON round-trip', () {
    test('preserves all fields', () {
      final restored = ExerciseEntry.fromJson(buildEntry().toJson());
      expect(restored.id, 'ex1');
      expect(restored.name, 'Squat');
      expect(restored.sets, hasLength(3));
      expect(restored.sets[1].reps, 6);
      expect(restored.sets[1].weightKg, 70);
      expect(restored.timestamp, DateTime(2026, 7, 1, 10, 30));
    });

    test('missing sets list defaults to empty', () {
      final restored = ExerciseEntry.fromJson({'id': 'e', 'name': 'X'});
      expect(restored.sets, isEmpty);
    });
  });
}
