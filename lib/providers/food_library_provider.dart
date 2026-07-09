import 'package:flutter/foundation.dart';
import '../models/food_category.dart';
import '../models/recipe.dart';
import '../models/saved_food.dart';
import '../services/storage_service.dart';

/// Owns the food library: saved foods, their categories and recipes.
/// Persisted separately from the daily nutrition state so library edits
/// don't rebuild dashboard listeners.
class FoodLibraryProvider extends ChangeNotifier {
  final StorageService _storage;

  FoodLibraryProvider({StorageService? storage})
      : _storage = storage ?? StorageService();

  bool _isLoading = true;
  List<SavedFood> _foods = [];
  List<FoodCategory> _categories = [];
  List<Recipe> _recipes = [];

  bool get isLoading => _isLoading;
  List<SavedFood> get savedFoods => List.unmodifiable(_foods);
  List<Recipe> get recipes => List.unmodifiable(_recipes);

  List<FoodCategory> get categories {
    final sorted = [..._categories]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return List.unmodifiable(sorted);
  }

  Future<void> init() async {
    await _storage.ensureInitialized();
    // Own growable copies — never mutate lists handed out by storage.
    _foods = List.of(await _storage.loadSavedFoods());

    // Seed default categories only on true first run (key never written).
    final storedCategories = await _storage.loadFoodCategories();
    if (storedCategories == null) {
      _categories = FoodCategory.defaults();
      await _storage.saveFoodCategories(_categories);
    } else {
      _categories = List.of(storedCategories);
    }

    _recipes = List.of(await _storage.loadRecipes());
    await _migrateLegacyFavorites();
    _isLoading = false;
    notifyListeners();
  }

  /// Converts pre-library favorites (`List<Meal>` under 'favorite_meals') into
  /// SavedFoods in the "General" bucket. Idempotent: keyed off the legacy
  /// key's presence, which is cleared after a successful save. Re-importing
  /// an old backup rewrites the legacy key, so the next init re-migrates.
  Future<void> _migrateLegacyFavorites() async {
    final legacy = await _storage.loadFavoriteMeals();
    if (legacy.isEmpty) return;
    final existingIds = _foods.map((f) => f.id).toSet();
    for (final meal in legacy) {
      if (existingIds.contains(meal.id)) continue;
      _foods.add(SavedFood(
        id: meal.id,
        name: meal.name,
        calories: meal.calories,
        protein: meal.protein,
        carbs: meal.carbs,
        fat: meal.fat,
        barcode: meal.barcode,
        extraNutrients: meal.extraNutrients,
        categoryId: null,
        createdAt: meal.timestamp,
      ));
    }
    await _storage.saveSavedFoods(_foods);
    await _storage.clearLegacyFavorites();
  }

  // ── Saved foods ───────────────────────────────

  List<SavedFood> foodsInCategory(String? categoryId) =>
      _foods.where((f) => f.categoryId == categoryId).toList();

  SavedFood? savedFoodByBarcode(String barcode) {
    for (final f in _foods) {
      if (f.barcode == barcode) return f;
    }
    return null;
  }

  Future<void> addSavedFood(SavedFood food) async {
    // De-dupe by case-insensitive name: update the existing entry instead of
    // creating a near-identical sibling (mirrors the old favorites behavior).
    final idx = _foods.indexWhere(
      (f) => f.name.toLowerCase() == food.name.toLowerCase(),
    );
    if (idx >= 0) {
      final existing = _foods[idx];
      // Keep the stored id/createdAt so recipe provenance links stay valid.
      _foods[idx] = SavedFood(
        id: existing.id,
        name: food.name,
        calories: food.calories,
        protein: food.protein,
        carbs: food.carbs,
        fat: food.fat,
        barcode: food.barcode,
        extraNutrients: food.extraNutrients,
        categoryId: food.categoryId ?? existing.categoryId,
        createdAt: existing.createdAt,
      );
    } else {
      _foods.add(food);
    }
    await _storage.saveSavedFoods(_foods);
    notifyListeners();
  }

  Future<void> updateSavedFood(SavedFood food) async {
    final idx = _foods.indexWhere((f) => f.id == food.id);
    if (idx < 0) return;
    _foods[idx] = food;
    await _storage.saveSavedFoods(_foods);
    notifyListeners();
  }

  Future<void> deleteSavedFood(String id) async {
    _foods.removeWhere((f) => f.id == id);
    await _storage.saveSavedFoods(_foods);
    notifyListeners();
  }

  // ── Categories ────────────────────────────────

  Future<void> addCategory(String name) async {
    final nextOrder = _categories.isEmpty
        ? 0
        : _categories
                .map((c) => c.sortOrder)
                .reduce((a, b) => a > b ? a : b) +
            1;
    _categories.add(FoodCategory(
      id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      sortOrder: nextOrder,
    ));
    await _storage.saveFoodCategories(_categories);
    notifyListeners();
  }

  Future<void> renameCategory(String id, String name) async {
    final idx = _categories.indexWhere((c) => c.id == id);
    if (idx < 0) return;
    _categories[idx] = _categories[idx].copyWith(name: name);
    await _storage.saveFoodCategories(_categories);
    notifyListeners();
  }

  /// Deletes a category; its foods fall back to the "General" bucket.
  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
    var foodsChanged = false;
    for (var i = 0; i < _foods.length; i++) {
      if (_foods[i].categoryId == id) {
        _foods[i] = _foods[i].copyWith(categoryId: null);
        foodsChanged = true;
      }
    }
    await _storage.saveFoodCategories(_categories);
    if (foodsChanged) await _storage.saveSavedFoods(_foods);
    notifyListeners();
  }

  // ── Recipes ───────────────────────────────────

  Future<void> addRecipe(Recipe recipe) async {
    _recipes.add(recipe);
    await _storage.saveRecipes(_recipes);
    notifyListeners();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final idx = _recipes.indexWhere((r) => r.id == recipe.id);
    if (idx < 0) return;
    _recipes[idx] = recipe;
    await _storage.saveRecipes(_recipes);
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    _recipes.removeWhere((r) => r.id == id);
    await _storage.saveRecipes(_recipes);
    notifyListeners();
  }
}
