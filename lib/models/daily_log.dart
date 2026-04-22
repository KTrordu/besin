import 'meal.dart';

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

class DailyLog {
  final DateTime date;
  final List<Meal> meals;
  final DailyGoals goals;

  const DailyLog({
    required this.date,
    required this.meals,
    required this.goals,
  });

  double get totalCalories => meals.fold(0, (s, m) => s + m.calories);
  double get totalProtein => meals.fold(0, (s, m) => s + m.protein);
  double get totalCarbs => meals.fold(0, (s, m) => s + m.carbs);
  double get totalFat => meals.fold(0, (s, m) => s + m.fat);

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'meals': meals.map((m) => m.toJson()).toList(),
        'goals': goals.toJson(),
      };

  factory DailyLog.fromJson(Map<String, dynamic> json) => DailyLog(
        date: DateTime.parse(json['date'] as String),
        meals: (json['meals'] as List<dynamic>)
            .map((m) => Meal.fromJson(m as Map<String, dynamic>))
            .toList(),
        goals: DailyGoals.fromJson(json['goals'] as Map<String, dynamic>),
      );

  DailyLog copyWith({
    DateTime? date,
    List<Meal>? meals,
    DailyGoals? goals,
  }) =>
      DailyLog(
        date: date ?? this.date,
        meals: meals ?? this.meals,
        goals: goals ?? this.goals,
      );
}
