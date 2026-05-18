import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kalori_takip/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StorageService — buildBackupMap', () {
    test('includes version 1 and an exportDate string', () async {
      final s = StorageService();
      await s.ensureInitialized();
      final map = s.buildBackupMap();
      expect(map['version'], 1);
      expect(map['exportDate'], isA<String>());
    });

    test('default bool settings are present with correct defaults', () async {
      final s = StorageService();
      await s.ensureInitialized();
      final map = s.buildBackupMap();
      expect(map['enableWorkoutTracking'], true);
      expect(map['trackProtein'], true);
      expect(map['trackCarbs'], true);
      expect(map['trackFat'], true);
      expect(map['streakRequireCalories'], true);
      expect(map['streakRequireProtein'], true);
      expect(map['streakRequireCarbs'], false);
      expect(map['streakRequireFat'], false);
      expect(map['streakThreshold'], closeTo(0.90, 0.001));
    });

    test('reflects non-default values stored in prefs', () async {
      SharedPreferences.setMockInitialValues({
        'enable_workout_tracking': false,
        'track_fat': false,
        'streak_threshold': 0.75,
        'streak_require_carbs': true,
      });
      final s = StorageService();
      await s.ensureInitialized();
      final map = s.buildBackupMap();
      expect(map['enableWorkoutTracking'], false);
      expect(map['trackFat'], false);
      expect(map['streakThreshold'], closeTo(0.75, 0.001));
      expect(map['streakRequireCarbs'], true);
    });

    test('omits optional string keys when prefs have no data', () async {
      final s = StorageService();
      await s.ensureInitialized();
      final map = s.buildBackupMap();
      expect(map.containsKey('dailyLogs'), false);
      expect(map.containsKey('weightLogs'), false);
      expect(map.containsKey('defaultGoals'), false);
    });
  });

  group('StorageService — applyBackupMap', () {
    test('writes bool settings correctly', () async {
      final s = StorageService();
      await s.ensureInitialized();
      await s.applyBackupMap({
        'version': 1,
        'enableWorkoutTracking': false,
        'trackProtein': false,
        'trackCarbs': false,
        'trackFat': false,
        'streakRequireCalories': false,
        'streakRequireProtein': false,
        'streakRequireCarbs': true,
        'streakRequireFat': true,
        'streakThreshold': 0.65,
      });
      expect(await s.loadEnableWorkoutTracking(), false);
      expect(await s.loadTrackProtein(), false);
      expect(await s.loadTrackCarbs(), false);
      expect(await s.loadTrackFat(), false);
      expect(await s.loadStreakRequireCalories(), false);
      expect(await s.loadStreakRequireProtein(), false);
      expect(await s.loadStreakRequireCarbs(), true);
      expect(await s.loadStreakRequireFat(), true);
      expect(await s.loadStreakThreshold(), closeTo(0.65, 0.001));
    });

    test('handles streakThreshold stored as int (JSON edge case)', () async {
      final s = StorageService();
      await s.ensureInitialized();
      await s.applyBackupMap({'version': 1, 'streakThreshold': 1});
      expect(await s.loadStreakThreshold(), closeTo(1.0, 0.001));
    });

    test('ignores keys not present in the backup map', () async {
      SharedPreferences.setMockInitialValues({
        'track_protein': true,
        'streak_threshold': 0.90,
      });
      final s = StorageService();
      await s.ensureInitialized();
      // Apply a partial backup that only touches enableWorkoutTracking
      await s.applyBackupMap({'version': 1, 'enableWorkoutTracking': false});
      // Untouched values stay as they were
      expect(await s.loadTrackProtein(), true);
      expect(await s.loadStreakThreshold(), closeTo(0.90, 0.001));
      expect(await s.loadEnableWorkoutTracking(), false);
    });
  });

  group('StorageService — importDataFromJson', () {
    test('throws FormatException on invalid JSON', () async {
      final s = StorageService();
      await s.ensureInitialized();
      expect(
        () => s.importDataFromJson('not {{{{ valid json'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when root is a JSON array', () async {
      final s = StorageService();
      await s.ensureInitialized();
      expect(
        () => s.importDataFromJson('[1, 2, 3]'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when version field is missing', () async {
      final s = StorageService();
      await s.ensureInitialized();
      expect(
        () => s.importDataFromJson('{"no_version": true}'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when version is not an int', () async {
      final s = StorageService();
      await s.ensureInitialized();
      expect(
        () => s.importDataFromJson('{"version": "one"}'),
        throwsA(isA<FormatException>()),
      );
    });

    test('applies valid JSON to prefs', () async {
      final s = StorageService();
      await s.ensureInitialized();
      final json = jsonEncode({
        'version': 1,
        'enableWorkoutTracking': false,
        'trackFat': false,
        'streakThreshold': 0.70,
      });
      await s.importDataFromJson(json);
      expect(await s.loadEnableWorkoutTracking(), false);
      expect(await s.loadTrackFat(), false);
      expect(await s.loadStreakThreshold(), closeTo(0.70, 0.001));
    });
  });

  group('StorageService — round-trip (buildBackupMap → importDataFromJson)', () {
    test('all settings survive a full encode/decode cycle', () async {
      SharedPreferences.setMockInitialValues({
        'enable_workout_tracking': false,
        'track_protein': false,
        'track_carbs': false,
        'track_fat': false,
        'streak_require_calories': false,
        'streak_require_protein': false,
        'streak_require_carbs': true,
        'streak_require_fat': true,
        'streak_threshold': 0.80,
      });
      final s1 = StorageService();
      await s1.ensureInitialized();
      final jsonString = jsonEncode(s1.buildBackupMap());

      // Restore into fresh prefs
      SharedPreferences.setMockInitialValues({});
      final s2 = StorageService();
      await s2.ensureInitialized();
      await s2.importDataFromJson(jsonString);

      expect(await s2.loadEnableWorkoutTracking(), false);
      expect(await s2.loadTrackProtein(), false);
      expect(await s2.loadTrackCarbs(), false);
      expect(await s2.loadTrackFat(), false);
      expect(await s2.loadStreakRequireCalories(), false);
      expect(await s2.loadStreakRequireProtein(), false);
      expect(await s2.loadStreakRequireCarbs(), true);
      expect(await s2.loadStreakRequireFat(), true);
      expect(await s2.loadStreakThreshold(), closeTo(0.80, 0.001));
    });
  });
}
