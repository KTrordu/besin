// A recipe built from saved foods. Ingredients embed a snapshot of the food's
// nutrition values so the recipe never breaks when a library food is deleted
// and never changes silently when one is edited. [foodId] is provenance only.
class RecipeIngredient {
  final String id;
  final String? foodId;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  /// Serving multiplier — same semantics as Meal.quantity.
  final double quantity;

  const RecipeIngredient({
    required this.id,
    this.foodId,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.quantity = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'foodId': foodId,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'quantity': quantity,
      };

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      RecipeIngredient(
        id: json['id'] as String,
        foodId: json['foodId'] as String?,
        name: json['name'] as String,
        calories: (json['calories'] as num).toDouble(),
        protein: (json['protein'] as num?)?.toDouble() ?? 0,
        carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
        fat: (json['fat'] as num?)?.toDouble() ?? 0,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      );

  RecipeIngredient copyWith({
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? quantity,
  }) =>
      RecipeIngredient(
        id: id,
        foodId: foodId,
        name: name ?? this.name,
        calories: calories ?? this.calories,
        protein: protein ?? this.protein,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
        quantity: quantity ?? this.quantity,
      );
}

class Recipe {
  final String id;
  final String name;
  final List<RecipeIngredient> ingredients;
  final DateTime createdAt;

  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.createdAt,
  });

  double get totalCalories =>
      ingredients.fold(0, (s, i) => s + i.calories * i.quantity);
  double get totalProtein =>
      ingredients.fold(0, (s, i) => s + i.protein * i.quantity);
  double get totalCarbs =>
      ingredients.fold(0, (s, i) => s + i.carbs * i.quantity);
  double get totalFat =>
      ingredients.fold(0, (s, i) => s + i.fat * i.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        name: json['name'] as String,
        ingredients: (json['ingredients'] as List<dynamic>? ?? const [])
            .map((i) => RecipeIngredient.fromJson(i as Map<String, dynamic>))
            .toList(),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );

  Recipe copyWith({String? name, List<RecipeIngredient>? ingredients}) =>
      Recipe(
        id: id,
        name: name ?? this.name,
        ingredients: ingredients ?? this.ingredients,
        createdAt: createdAt,
      );
}
