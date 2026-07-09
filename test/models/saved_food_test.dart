import 'package:flutter_test/flutter_test.dart';
import 'package:kalori_takip/models/saved_food.dart';

void main() {
  group('SavedFood — JSON round-trip', () {
    test('preserves all fields', () {
      final food = SavedFood(
        id: 'f1',
        name: 'Yulaf',
        calories: 370,
        protein: 13,
        carbs: 60,
        fat: 7,
        barcode: '8690000000000',
        extraNutrients: const {'Lif': 10.5},
        categoryId: 'cat_breakfast',
        createdAt: DateTime(2026, 1, 15, 8, 30),
      );
      final restored = SavedFood.fromJson(food.toJson());
      expect(restored.id, food.id);
      expect(restored.name, food.name);
      expect(restored.calories, food.calories);
      expect(restored.protein, food.protein);
      expect(restored.carbs, food.carbs);
      expect(restored.fat, food.fat);
      expect(restored.barcode, food.barcode);
      expect(restored.extraNutrients, food.extraNutrients);
      expect(restored.categoryId, food.categoryId);
      expect(restored.createdAt, food.createdAt);
    });

    test('nullable fields default safely from minimal JSON', () {
      final restored = SavedFood.fromJson({
        'id': 'f1',
        'name': 'Elma',
        'calories': 52,
      });
      expect(restored.protein, 0);
      expect(restored.barcode, isNull);
      expect(restored.extraNutrients, isEmpty);
      expect(restored.categoryId, isNull);
    });
  });

  group('SavedFood — copyWith', () {
    final base = SavedFood(
      id: 'f1',
      name: 'Yulaf',
      calories: 370,
      protein: 13,
      carbs: 60,
      fat: 7,
      barcode: '123',
      categoryId: 'cat_a',
      createdAt: DateTime(2026, 1, 1),
    );

    test('keeps barcode and categoryId when omitted', () {
      final copy = base.copyWith(name: 'Yulaf Ezmesi');
      expect(copy.barcode, '123');
      expect(copy.categoryId, 'cat_a');
    });

    test('can explicitly null barcode and categoryId', () {
      final copy = base.copyWith(barcode: null, categoryId: null);
      expect(copy.barcode, isNull);
      expect(copy.categoryId, isNull);
    });
  });
}
