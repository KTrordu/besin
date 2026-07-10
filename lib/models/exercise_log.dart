import 'dart:math' as math;

// One set of an exercise: repetitions at a given weight.
class ExerciseSet {
  final int reps;
  final double weightKg;

  const ExerciseSet({required this.reps, required this.weightKg});

  Map<String, dynamic> toJson() => {'reps': reps, 'weightKg': weightKg};

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
        reps: (json['reps'] as num?)?.toInt() ?? 0,
        weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      );
}

// One exercise performed on a day (free-text name + its sets).
class ExerciseEntry {
  final String id;
  final String name;
  final List<ExerciseSet> sets;
  final DateTime timestamp;

  const ExerciseEntry({
    required this.id,
    required this.name,
    required this.sets,
    required this.timestamp,
  });

  double get totalVolume =>
      sets.fold(0, (s, x) => s + x.reps * x.weightKg);
  double get maxWeight =>
      sets.fold(0, (s, x) => math.max(s, x.weightKg));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sets': sets.map((s) => s.toJson()).toList(),
        'timestamp': timestamp.toIso8601String(),
      };

  factory ExerciseEntry.fromJson(Map<String, dynamic> json) => ExerciseEntry(
        id: json['id'] as String,
        name: json['name'] as String,
        sets: (json['sets'] as List<dynamic>? ?? const [])
            .map((s) => ExerciseSet.fromJson(s as Map<String, dynamic>))
            .toList(),
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );

  ExerciseEntry copyWith({String? name, List<ExerciseSet>? sets}) =>
      ExerciseEntry(
        id: id,
        name: name ?? this.name,
        sets: sets ?? this.sets,
        timestamp: timestamp,
      );
}

// A reusable exercise template: name + default sets. Tapping it on the
// workout screen logs a fresh [ExerciseEntry] for the selected day.
class SavedExercise {
  final String id;
  final String name;
  final List<ExerciseSet> sets;
  final DateTime createdAt;

  const SavedExercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sets': sets.map((s) => s.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavedExercise.fromJson(Map<String, dynamic> json) => SavedExercise(
        id: json['id'] as String,
        name: json['name'] as String,
        sets: (json['sets'] as List<dynamic>? ?? const [])
            .map((s) => ExerciseSet.fromJson(s as Map<String, dynamic>))
            .toList(),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );
}
