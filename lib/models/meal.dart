enum MealType { breakfast, lunch, dinner, snack, extra }

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Kahvaltı';
      case MealType.lunch:
        return 'Öğle';
      case MealType.dinner:
        return 'Akşam';
      case MealType.snack:
        return 'Ara Öğün';
      case MealType.extra:
        return 'Atıştırmalık';
    }
  }
}

class Meal {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime timestamp;
  final MealType mealType;
  final bool isFavorite;
  final double quantity;
  final String? barcode;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.timestamp,
    required this.mealType,
    this.isFavorite = false,
    this.quantity = 1.0,
    this.barcode,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'timestamp': timestamp.toIso8601String(),
        'mealType': mealType.index,
        'isFavorite': isFavorite,
        'quantity': quantity,
        'barcode': barcode,
      };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json['id'] as String,
        name: json['name'] as String,
        calories: (json['calories'] as num).toDouble(),
        protein: (json['protein'] as num).toDouble(),
        carbs: (json['carbs'] as num).toDouble(),
        fat: (json['fat'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
        mealType: MealType.values[json['mealType'] as int],
        isFavorite: json['isFavorite'] as bool? ?? false,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
        barcode: json['barcode'] as String?,
      );

  Meal copyWith({
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    DateTime? timestamp,
    MealType? mealType,
    bool? isFavorite,
    double? quantity,
    String? barcode,
  }) =>
      Meal(
        id: id,
        name: name ?? this.name,
        calories: calories ?? this.calories,
        protein: protein ?? this.protein,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
        timestamp: timestamp ?? this.timestamp,
        mealType: mealType ?? this.mealType,
        isFavorite: isFavorite ?? this.isFavorite,
        quantity: quantity ?? this.quantity,
        barcode: barcode ?? this.barcode,
      );
}
