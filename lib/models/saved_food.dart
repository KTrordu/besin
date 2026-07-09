// A food saved in the user's library ("Besinlerim"). Unlike [Meal] it is not
// tied to a day — no timestamp-of-consumption, meal type or quantity. Macro
// values are per single serving (base values, never quantity-multiplied).
class SavedFood {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String? barcode;
  final Map<String, double> extraNutrients;

  /// Null means the virtual "General" bucket.
  final String? categoryId;
  final DateTime createdAt;

  const SavedFood({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.barcode,
    this.extraNutrients = const {},
    this.categoryId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'barcode': barcode,
        'extraNutrients': extraNutrients,
        'categoryId': categoryId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavedFood.fromJson(Map<String, dynamic> json) => SavedFood(
        id: json['id'] as String,
        name: json['name'] as String,
        calories: (json['calories'] as num).toDouble(),
        protein: (json['protein'] as num?)?.toDouble() ?? 0,
        carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
        fat: (json['fat'] as num?)?.toDouble() ?? 0,
        barcode: json['barcode'] as String?,
        extraNutrients:
            (json['extraNutrients'] as Map<String, dynamic>?)?.map(
                  (k, v) => MapEntry(k, (v as num).toDouble()),
                ) ??
                const {},
        categoryId: json['categoryId'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );

  // Sentinel for nullable copyWith — avoids the double-null ambiguity.
  static const _keep = Object();

  SavedFood copyWith({
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    Object? barcode = _keep,
    Map<String, double>? extraNutrients,
    Object? categoryId = _keep,
  }) =>
      SavedFood(
        id: id,
        name: name ?? this.name,
        calories: calories ?? this.calories,
        protein: protein ?? this.protein,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
        barcode: barcode == _keep ? this.barcode : barcode as String?,
        extraNutrients: extraNutrients ?? this.extraNutrients,
        categoryId:
            categoryId == _keep ? this.categoryId : categoryId as String?,
        createdAt: createdAt,
      );
}
