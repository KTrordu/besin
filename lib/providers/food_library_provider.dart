import 'package:flutter/foundation.dart';
import '../models/food_category.dart';
import '../models/food_category_sort_preset.dart';
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
  List<FoodCategorySortPreset> _categorySortPresets = [];
  FoodCategorySortSelection _categorySortSelection =
      const FoodCategorySortSelection();

  bool get isLoading => _isLoading;
  List<SavedFood> get savedFoods => List.unmodifiable(_foods);
  List<Recipe> get recipes => List.unmodifiable(_recipes);
  List<FoodCategorySortPreset> get categorySortPresets =>
      List.unmodifiable(_categorySortPresets);
  FoodCategorySortSelection get categorySortSelection => _categorySortSelection;

  List<FoodCategory> get categories {
    final sorted = [..._categories]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return List.unmodifiable(sorted);
  }

  List<FoodCategory> sortedCategories(
    String Function(FoodCategory category) displayName,
  ) {
    final sorted = [..._categories];
    switch (_categorySortSelection.mode) {
      case FoodCategorySortMode.manual:
        sorted.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      case FoodCategorySortMode.alphabetical:
        sorted.sort(
          (a, b) => displayName(
            a,
          ).toLowerCase().compareTo(displayName(b).toLowerCase()),
        );
      case FoodCategorySortMode.newest:
        sorted.sort((a, b) => b.createdAtMillis.compareTo(a.createdAtMillis));
      case FoodCategorySortMode.oldest:
        sorted.sort((a, b) => a.createdAtMillis.compareTo(b.createdAtMillis));
      case FoodCategorySortMode.preset:
        final preset = _presetById(_categorySortSelection.presetId);
        if (preset == null) {
          sorted.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
          break;
        }
        final positions = <String, int>{
          for (var i = 0; i < preset.categoryIds.length; i++)
            preset.categoryIds[i]: i,
        };
        sorted.sort((a, b) {
          final aIndex = positions[a.id] ?? preset.categoryIds.length;
          final bIndex = positions[b.id] ?? preset.categoryIds.length;
          final order = aIndex.compareTo(bIndex);
          return order != 0 ? order : a.sortOrder.compareTo(b.sortOrder);
        });
    }
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
    _categorySortPresets = List.of(
      await _storage.loadFoodCategorySortPresets(),
    );
    _categorySortSelection = await _storage.loadFoodCategorySortSelection();
    if (_categorySortSelection.mode == FoodCategorySortMode.preset &&
        _presetById(_categorySortSelection.presetId) == null) {
      _categorySortSelection = const FoodCategorySortSelection();
      await _storage.saveFoodCategorySortSelection(_categorySortSelection);
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
      _foods.add(
        SavedFood(
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
        ),
      );
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
        : _categories.map((c) => c.sortOrder).reduce((a, b) => a > b ? a : b) +
              1;
    _categories.add(
      FoodCategory(
        id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        sortOrder: nextOrder,
        createdAtMillis: DateTime.now().millisecondsSinceEpoch,
      ),
    );
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
    _categorySortPresets = _categorySortPresets
        .map(
          (preset) => FoodCategorySortPreset(
            id: preset.id,
            name: preset.name,
            categoryIds: preset.categoryIds
                .where((item) => item != id)
                .toList(),
          ),
        )
        .toList();
    await _storage.saveFoodCategorySortPresets(_categorySortPresets);
    if (foodsChanged) await _storage.saveSavedFoods(_foods);
    notifyListeners();
  }

  FoodCategorySortPreset? _presetById(String? id) {
    if (id == null) return null;
    for (final preset in _categorySortPresets) {
      if (preset.id == id) return preset;
    }
    return null;
  }

  Future<void> selectCategorySort(FoodCategorySortSelection selection) async {
    _categorySortSelection = selection;
    await _storage.saveFoodCategorySortSelection(selection);
    notifyListeners();
  }

  Future<void> reorderCategories(List<String> categoryIds) async {
    if (_categorySortSelection.mode == FoodCategorySortMode.preset) {
      final idx = _categorySortPresets.indexWhere(
        (preset) => preset.id == _categorySortSelection.presetId,
      );
      if (idx >= 0) {
        final preset = _categorySortPresets[idx];
        _categorySortPresets[idx] = FoodCategorySortPreset(
          id: preset.id,
          name: preset.name,
          categoryIds: List.of(categoryIds),
        );
        await _storage.saveFoodCategorySortPresets(_categorySortPresets);
      }
    } else {
      _categorySortSelection = const FoodCategorySortSelection();
      for (var i = 0; i < categoryIds.length; i++) {
        final idx = _categories.indexWhere((c) => c.id == categoryIds[i]);
        if (idx >= 0) {
          _categories[idx] = _categories[idx].copyWith(sortOrder: i);
        }
      }
      await _storage.saveFoodCategories(_categories);
      await _storage.saveFoodCategorySortSelection(_categorySortSelection);
    }
    notifyListeners();
  }

  Future<void> addCategorySortPreset(
    String name,
    List<String> categoryIds,
  ) async {
    final preset = FoodCategorySortPreset(
      id: 'category_sort_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      categoryIds: List.of(categoryIds),
    );
    _categorySortPresets.add(preset);
    _categorySortSelection = FoodCategorySortSelection(
      mode: FoodCategorySortMode.preset,
      presetId: preset.id,
    );
    await _storage.saveFoodCategorySortPresets(_categorySortPresets);
    await _storage.saveFoodCategorySortSelection(_categorySortSelection);
    notifyListeners();
  }

  Future<void> deleteCategorySortPreset(String id) async {
    _categorySortPresets.removeWhere((preset) => preset.id == id);
    if (_categorySortSelection.presetId == id) {
      _categorySortSelection = const FoodCategorySortSelection();
      await _storage.saveFoodCategorySortSelection(_categorySortSelection);
    }
    await _storage.saveFoodCategorySortPresets(_categorySortPresets);
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
