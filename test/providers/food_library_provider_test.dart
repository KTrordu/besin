import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kalori_takip/models/food_category.dart';
import 'package:kalori_takip/models/meal.dart';
import 'package:kalori_takip/models/recipe.dart';
import 'package:kalori_takip/models/saved_food.dart';
import 'package:kalori_takip/providers/food_library_provider.dart';
import 'package:kalori_takip/services/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

void _stubStorage(
  MockStorageService s, {
  List<SavedFood> foods = const [],
  List<FoodCategory>? categories,
  List<Recipe> recipes = const [],
  List<Meal> legacyFavorites = const [],
}) {
  when(() => s.ensureInitialized()).thenAnswer((_) async {});
  when(() => s.loadSavedFoods()).thenAnswer((_) async => List.of(foods));
  when(() => s.loadFoodCategories()).thenAnswer((_) async => categories);
  when(() => s.loadRecipes()).thenAnswer((_) async => List.of(recipes));
  when(() => s.loadFavoriteMeals())
      .thenAnswer((_) async => List.of(legacyFavorites));
  when(() => s.saveSavedFoods(any())).thenAnswer((_) async {});
  when(() => s.saveFoodCategories(any())).thenAnswer((_) async {});
  when(() => s.saveRecipes(any())).thenAnswer((_) async {});
  when(() => s.clearLegacyFavorites()).thenAnswer((_) async {});
}

void main() {
  setUpAll(() {
    registerFallbackValue(<SavedFood>[]);
    registerFallbackValue(<FoodCategory>[]);
    registerFallbackValue(<Recipe>[]);
  });

  group('FoodLibraryProvider — init & category seeding', () {
    test('seeds default categories only when the key was never written',
        () async {
      final s = MockStorageService();
      _stubStorage(s, categories: null);
      final p = FoodLibraryProvider(storage: s);
      await p.init();
      expect(p.categories.map((c) => c.builtinKey),
          containsAll(['breakfast', 'protein', 'snacks']));
      verify(() => s.saveFoodCategories(any())).called(1);
    });

    test('an explicitly empty stored list is respected (no re-seeding)',
        () async {
      final s = MockStorageService();
      _stubStorage(s, categories: const []);
      final p = FoodLibraryProvider(storage: s);
      await p.init();
      expect(p.categories, isEmpty);
      verifyNever(() => s.saveFoodCategories(any()));
    });
  });

  group('FoodLibraryProvider — legacy favorites migration', () {
    Meal legacyMeal(String id) => Meal(
          id: id,
          name: 'Menemen $id',
          calories: 300,
          protein: 15,
          carbs: 10,
          fat: 20,
          timestamp: DateTime(2025, 6, 1, 9),
          mealType: MealType.breakfast,
          barcode: '869$id',
          extraNutrients: const {'Lif': 2.0},
        );

    test('converts legacy meals preserving id, barcode and extraNutrients',
        () async {
      final s = MockStorageService();
      _stubStorage(s, legacyFavorites: [legacyMeal('a')]);
      final p = FoodLibraryProvider(storage: s);
      await p.init();

      expect(p.savedFoods, hasLength(1));
      final f = p.savedFoods.single;
      expect(f.id, 'a');
      expect(f.barcode, '869a');
      expect(f.extraNutrients['Lif'], 2.0);
      expect(f.categoryId, isNull); // lands in the General bucket
      verify(() => s.saveSavedFoods(any())).called(1);
      verify(() => s.clearLegacyFavorites()).called(1);
    });

    test('skips legacy meals whose id already exists (idempotent)', () async {
      final s = MockStorageService();
      final existing = SavedFood(
        id: 'a',
        name: 'Zaten var',
        calories: 100,
        protein: 1,
        carbs: 1,
        fat: 1,
        createdAt: DateTime(2026, 1, 1),
      );
      _stubStorage(s, foods: [existing], legacyFavorites: [legacyMeal('a')]);
      final p = FoodLibraryProvider(storage: s);
      await p.init();
      expect(p.savedFoods, hasLength(1));
      expect(p.savedFoods.single.name, 'Zaten var');
    });

    test('does nothing when there are no legacy favorites', () async {
      final s = MockStorageService();
      _stubStorage(s);
      final p = FoodLibraryProvider(storage: s);
      await p.init();
      verifyNever(() => s.clearLegacyFavorites());
    });
  });

  group('FoodLibraryProvider — saved foods', () {
    test('addSavedFood dedupes by case-insensitive name, keeping stored id',
        () async {
      final s = MockStorageService();
      final existing = SavedFood(
        id: 'old',
        name: 'Yulaf',
        calories: 350,
        protein: 12,
        carbs: 58,
        fat: 6,
        categoryId: 'cat_x',
        createdAt: DateTime(2026, 1, 1),
      );
      _stubStorage(s, foods: [existing], categories: const []);
      final p = FoodLibraryProvider(storage: s);
      await p.init();

      await p.addSavedFood(SavedFood(
        id: 'new',
        name: 'YULAF',
        calories: 370,
        protein: 13,
        carbs: 60,
        fat: 7,
        createdAt: DateTime(2026, 7, 9),
      ));

      expect(p.savedFoods, hasLength(1));
      final f = p.savedFoods.single;
      expect(f.id, 'old');
      expect(f.createdAt, DateTime(2026, 1, 1));
      expect(f.calories, 370);
      expect(f.categoryId, 'cat_x'); // kept when the new food has none
    });

    test('savedFoodByBarcode finds the matching food', () async {
      final s = MockStorageService();
      final food = SavedFood(
        id: 'f1',
        name: 'Süt',
        calories: 60,
        protein: 3,
        carbs: 5,
        fat: 3,
        barcode: '8690001',
        createdAt: DateTime(2026, 1, 1),
      );
      _stubStorage(s, foods: [food], categories: const []);
      final p = FoodLibraryProvider(storage: s);
      await p.init();
      expect(p.savedFoodByBarcode('8690001')?.id, 'f1');
      expect(p.savedFoodByBarcode('yok'), isNull);
    });
  });

  group('FoodLibraryProvider — categories', () {
    test('deleteCategory moves its foods to the General bucket', () async {
      final s = MockStorageService();
      const cat = FoodCategory(id: 'cat_x', name: 'Atıştırma', sortOrder: 0);
      final food = SavedFood(
        id: 'f1',
        name: 'Fındık',
        calories: 600,
        protein: 15,
        carbs: 17,
        fat: 61,
        categoryId: 'cat_x',
        createdAt: DateTime(2026, 1, 1),
      );
      _stubStorage(s, foods: [food], categories: const [cat]);
      final p = FoodLibraryProvider(storage: s);
      await p.init();

      await p.deleteCategory('cat_x');
      expect(p.categories, isEmpty);
      expect(p.savedFoods.single.categoryId, isNull);
      expect(p.foodsInCategory(null), hasLength(1));
    });
  });
}
