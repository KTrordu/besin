import 'package:flutter_test/flutter_test.dart';
import 'package:kalori_takip/models/recipe.dart';

void main() {
  Recipe buildRecipe() => Recipe(
        id: 'r1',
        name: 'Overnight oats',
        ingredients: const [
          RecipeIngredient(
            id: 'i1',
            foodId: 'f1',
            name: 'Yulaf',
            calories: 370,
            protein: 13,
            carbs: 60,
            fat: 7,
            quantity: 0.5,
          ),
          RecipeIngredient(
            id: 'i2',
            name: 'Süt',
            calories: 60,
            protein: 3,
            carbs: 5,
            fat: 3,
            quantity: 2,
          ),
        ],
        createdAt: DateTime(2026, 2, 1),
      );

  group('Recipe — totals', () {
    test('totals are quantity-weighted sums of ingredients', () {
      final r = buildRecipe();
      expect(r.totalCalories, closeTo(370 * 0.5 + 60 * 2, 0.001));
      expect(r.totalProtein, closeTo(13 * 0.5 + 3 * 2, 0.001));
      expect(r.totalCarbs, closeTo(60 * 0.5 + 5 * 2, 0.001));
      expect(r.totalFat, closeTo(7 * 0.5 + 3 * 2, 0.001));
    });
  });

  group('Recipe — JSON round-trip', () {
    test('preserves ingredients including foodId provenance', () {
      final restored = Recipe.fromJson(buildRecipe().toJson());
      expect(restored.ingredients, hasLength(2));
      expect(restored.ingredients[0].foodId, 'f1');
      expect(restored.ingredients[0].quantity, 0.5);
      expect(restored.ingredients[1].foodId, isNull);
      expect(restored.totalCalories, closeTo(305, 0.001));
    });

    test('missing ingredients list defaults to empty', () {
      final restored = Recipe.fromJson({'id': 'r1', 'name': 'Boş'});
      expect(restored.ingredients, isEmpty);
      expect(restored.totalCalories, 0);
    });
  });
}
