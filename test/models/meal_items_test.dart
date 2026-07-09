import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalori_takip/models/meal.dart';

void main() {
  const items = [
    MealItem(
        id: 'i1', name: 'Tavuk', calories: 165, protein: 31, carbs: 0, fat: 4),
    MealItem(
        id: 'i2',
        name: 'Pilav',
        calories: 130,
        protein: 2.7,
        carbs: 28,
        fat: 0.3,
        quantity: 1.5),
  ];

  group('Meal.fromItems — denormalized totals', () {
    test('stored macros equal quantity-weighted item sums', () {
      final meal = Meal.fromItems(
        id: 'm1',
        name: 'Tavuklu pilav',
        items: items,
        timestamp: DateTime(2026, 7, 9, 12),
        mealType: MealType.lunch,
      );
      expect(meal.calories, closeTo(165 + 130 * 1.5, 0.001));
      expect(meal.protein, closeTo(31 + 2.7 * 1.5, 0.001));
      expect(meal.carbs, closeTo(0 + 28 * 1.5, 0.001));
      expect(meal.fat, closeTo(4 + 0.3 * 1.5, 0.001));
      expect(meal.items, hasLength(2));
    });
  });

  group('Meal — items JSON round-trip', () {
    test('group meal survives toJson/fromJson', () {
      final meal = Meal.fromItems(
        id: 'm1',
        name: 'Tavuklu pilav',
        items: items,
        timestamp: DateTime(2026, 7, 9, 12),
        mealTime: const TimeOfDay(hour: 13, minute: 15),
        mealType: MealType.lunch,
      );
      final restored = Meal.fromJson(meal.toJson());
      expect(restored.items, hasLength(2));
      expect(restored.items[1].quantity, 1.5);
      expect(restored.calories, closeTo(meal.calories, 0.001));
      expect(restored.mealTime, const TimeOfDay(hour: 13, minute: 15));
    });

    test('plain meal omits items key and reads back empty', () {
      final meal = Meal(
        id: 'm2',
        name: 'Elma',
        calories: 52,
        protein: 0.3,
        carbs: 14,
        fat: 0.2,
        timestamp: DateTime(2026, 7, 9),
        mealType: MealType.snack,
      );
      final json = meal.toJson();
      expect(json.containsKey('items'), false);
      expect(Meal.fromJson(json).items, isEmpty);
    });
  });
}
