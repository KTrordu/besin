import 'meal.dart';

// ──────────────────────────────────────────────────
// WorkoutType
// ──────────────────────────────────────────────────

// New values always appended at end to preserve stored indices:
//   push=0, pull=1, legs=2, rest=3, none=4, light=5, upperBody=6, lowerBody=7
enum WorkoutType { push, pull, legs, rest, none, light, upperBody, lowerBody }

extension WorkoutTypeExtension on WorkoutType {
  String get displayName {
    switch (this) {
      case WorkoutType.push:
        return 'Push';
      case WorkoutType.pull:
        return 'Pull';
      case WorkoutType.legs:
        return 'Legs';
      case WorkoutType.rest:
        return 'Dinlenme';
      case WorkoutType.none:
        return 'Belirtilmedi';
      case WorkoutType.light:
        return 'Hafif Egzersiz';
      case WorkoutType.upperBody:
        return 'Upper Body';
      case WorkoutType.lowerBody:
        return 'Lower Body';
    }
  }
}

// ──────────────────────────────────────────────────
// DailyGoals
// ──────────────────────────────────────────────────

class DailyGoals {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const DailyGoals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  static const defaultGoals = DailyGoals(
    calories: 2000,
    protein: 150,
    carbs: 250,
    fat: 65,
  );

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };

  factory DailyGoals.fromJson(Map<String, dynamic> json) => DailyGoals(
        calories: (json['calories'] as num).toDouble(),
        protein: (json['protein'] as num).toDouble(),
        carbs: (json['carbs'] as num).toDouble(),
        fat: (json['fat'] as num).toDouble(),
      );

  DailyGoals copyWith({
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) =>
      DailyGoals(
        calories: calories ?? this.calories,
        protein: protein ?? this.protein,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
      );
}

// ──────────────────────────────────────────────────
// DailyLog
// ──────────────────────────────────────────────────

class DailyLog {
  final DateTime date;
  final List<Meal> meals;
  final DailyGoals goals;
  final WorkoutType workoutType;
  final bool isCheatDay;
  final int waterIntake;
  final bool isFlexibleMacroDay;
  // 'protein' | 'carbs' | 'fat' — null defaults to 'protein' in streak logic
  final String? flexibleMacroRequired;

  const DailyLog({
    required this.date,
    required this.meals,
    required this.goals,
    this.workoutType = WorkoutType.none,
    this.isCheatDay = false,
    this.waterIntake = 0,
    this.isFlexibleMacroDay = false,
    this.flexibleMacroRequired,
  });

  double get totalCalories => meals.fold(0, (s, m) => s + m.calories);
  double get totalProtein => meals.fold(0, (s, m) => s + m.protein);
  double get totalCarbs => meals.fold(0, (s, m) => s + m.carbs);
  double get totalFat => meals.fold(0, (s, m) => s + m.fat);

  Map<String, double> get totalExtraNutrients {
    final result = <String, double>{};
    for (final meal in meals) {
      for (final entry in meal.extraNutrients.entries) {
        result[entry.key] = (result[entry.key] ?? 0.0) + entry.value;
      }
    }
    return result;
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'meals': meals.map((m) => m.toJson()).toList(),
        'goals': goals.toJson(),
        'workoutType': workoutType.index,
        'isCheatDay': isCheatDay,
        'waterIntake': waterIntake,
        'isFlexibleMacroDay': isFlexibleMacroDay,
        if (flexibleMacroRequired != null)
          'flexibleMacroRequired': flexibleMacroRequired,
      };

  factory DailyLog.fromJson(Map<String, dynamic> json) => DailyLog(
        date: DateTime.parse(json['date'] as String),
        meals: (json['meals'] as List<dynamic>)
            .map((m) => Meal.fromJson(m as Map<String, dynamic>))
            .toList(),
        goals: DailyGoals.fromJson(json['goals'] as Map<String, dynamic>),
        workoutType: WorkoutType.values[
            (json['workoutType'] as num?)?.toInt() ?? WorkoutType.none.index],
        isCheatDay: (json['isCheatDay'] as bool?) ?? false,
        waterIntake: (json['waterIntake'] as num?)?.toInt() ?? 0,
        isFlexibleMacroDay: (json['isFlexibleMacroDay'] as bool?) ?? false,
        flexibleMacroRequired: json['flexibleMacroRequired'] as String?,
      );

  // Sentinel for nullable copyWith — avoids the double-null ambiguity.
  static const _keep = Object();

  DailyLog copyWith({
    DateTime? date,
    List<Meal>? meals,
    DailyGoals? goals,
    WorkoutType? workoutType,
    bool? isCheatDay,
    int? waterIntake,
    bool? isFlexibleMacroDay,
    Object? flexibleMacroRequired = _keep,
  }) =>
      DailyLog(
        date: date ?? this.date,
        meals: meals ?? this.meals,
        goals: goals ?? this.goals,
        workoutType: workoutType ?? this.workoutType,
        isCheatDay: isCheatDay ?? this.isCheatDay,
        waterIntake: waterIntake ?? this.waterIntake,
        isFlexibleMacroDay: isFlexibleMacroDay ?? this.isFlexibleMacroDay,
        flexibleMacroRequired: flexibleMacroRequired == _keep
            ? this.flexibleMacroRequired
            : flexibleMacroRequired as String?,
      );
}
