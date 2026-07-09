import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_l10n_ext.dart';
import '../l10n/app_localizations.dart';
import '../models/food_category.dart';
import '../models/recipe.dart';
import '../models/saved_food.dart';
import '../providers/food_library_provider.dart';
import 'recipe_edit_screen.dart';
import 'saved_food_edit_screen.dart';
import 'use_recipe_sheet.dart';

String _formatNum(double v) =>
    v.toStringAsFixed(1).replaceAll(RegExp(r'\.?0+$'), '');

/// "My Foods" tab: the food library (favorites grouped by category) and the
/// recipe book, as two top tabs sharing one bottom-nav destination.
class FoodsScreen extends StatefulWidget {
  const FoodsScreen({super.key});

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    if (_tabController.index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SavedFoodEditScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RecipeEditScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onRecipesTab = _tabController.index == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navFoods),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.foodsFavoritesTab),
            Tab(text: l10n.foodsRecipesTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _FavoritesTab(),
          _RecipesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        icon: const Icon(Icons.add),
        label: Text(onRecipesTab ? l10n.addRecipe : l10n.addFood),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Favorites tab: foods grouped by category
// ──────────────────────────────────────────────────

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab();

  Future<void> _addCategory(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final name = await _promptCategoryName(context, title: l10n.addCategory);
    if (name == null || !context.mounted) return;
    await context.read<FoodLibraryProvider>().addCategory(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lib = context.watch<FoodLibraryProvider>();
    final categories = lib.categories;
    final generalFoods = lib.foodsInCategory(null);

    if (lib.savedFoods.isEmpty && categories.isEmpty) {
      return _EmptyState(
        icon: Icons.star_outline,
        message: l10n.noSavedFoods,
        actionLabel: l10n.addCategory,
        onAction: () => _addCategory(context),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      children: [
        if (lib.savedFoods.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                l10n.noSavedFoods,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
        if (generalFoods.isNotEmpty) ...[
          _CategoryHeader(
            title: l10n.categoryGeneral,
            count: generalFoods.length,
          ),
          for (final f in generalFoods) _FoodTile(food: f),
        ],
        for (final c in categories) ...[
          _CategoryHeader(
            title: c.displayName(l10n),
            count: lib.foodsInCategory(c.id).length,
            category: c,
          ),
          for (final f in lib.foodsInCategory(c.id)) _FoodTile(food: f),
        ],
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => _addCategory(context),
          icon: const Icon(Icons.create_new_folder_outlined),
          label: Text(l10n.addCategory),
        ),
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.title,
    required this.count,
    this.category,
  });

  final String title;
  final int count;

  /// Null for the virtual "General" bucket (cannot be renamed or deleted).
  final FoodCategory? category;

  Future<void> _rename(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final name = await _promptCategoryName(
      context,
      title: l10n.renameCategory,
      initial: title,
    );
    if (name == null || !context.mounted) return;
    await context.read<FoodLibraryProvider>().renameCategory(
          category!.id,
          name,
        );
  }

  Future<void> _delete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _confirmDialog(
      context,
      title: l10n.deleteCategory,
      message: l10n.deleteCategoryConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await context.read<FoodLibraryProvider>().deleteCategory(category!.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Row(
        children: [
          Icon(Icons.folder_outlined, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: cs.primary,
                  ),
            ),
          ),
          Text(
            l10n.foodCount(count),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
          if (category != null)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 18, color: cs.onSurfaceVariant),
              onSelected: (v) {
                if (v == 'rename') _rename(context);
                if (v == 'delete') _delete(context);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'rename',
                  child: Text(l10n.renameCategory),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(l10n.deleteCategory),
                ),
              ],
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _FoodTile extends StatelessWidget {
  const _FoodTile({required this.food});

  final SavedFood food;

  Future<void> _delete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _confirmDialog(
      context,
      title: l10n.deleteFood,
      message: l10n.deleteFoodConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await context.read<FoodLibraryProvider>().deleteSavedFood(food.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading:
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
        title: Text(food.name),
        subtitle: Text(
          '${food.calories.toStringAsFixed(0)} kcal'
          ' · ${l10n.protein.substring(0, 1)} ${_formatNum(food.protein)}'
          ' · ${l10n.carbs.substring(0, 1)} ${_formatNum(food.carbs)}'
          ' · ${l10n.fat.substring(0, 1)} ${_formatNum(food.fat)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () => _delete(context),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SavedFoodEditScreen(food: food),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Recipes tab
// ──────────────────────────────────────────────────

class _RecipesTab extends StatelessWidget {
  const _RecipesTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final recipes = context.watch<FoodLibraryProvider>().recipes;

    if (recipes.isEmpty) {
      return _EmptyState(
        icon: Icons.menu_book_outlined,
        message: l10n.noRecipes,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      itemCount: recipes.length,
      itemBuilder: (context, index) =>
          _RecipeCard(recipe: recipes[index]),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe});

  final Recipe recipe;

  Future<void> _delete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _confirmDialog(
      context,
      title: l10n.deleteRecipe,
      message: l10n.deleteRecipeConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await context.read<FoodLibraryProvider>().deleteRecipe(recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(Icons.menu_book_outlined, color: cs.primary),
            title: Text(recipe.name),
            subtitle: Text(
              '${l10n.ingredientCount(recipe.ingredients.length)}'
              ' · ${recipe.totalCalories.toStringAsFixed(0)} kcal'
              ' · ${l10n.protein.substring(0, 1)} ${_formatNum(recipe.totalProtein)}'
              ' · ${l10n.carbs.substring(0, 1)} ${_formatNum(recipe.totalCarbs)}'
              ' · ${l10n.fat.substring(0, 1)} ${_formatNum(recipe.totalFat)}',
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeEditScreen(recipe: recipe),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _delete(context),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(l10n.delete),
                  style: TextButton.styleFrom(foregroundColor: cs.error),
                ),
                const SizedBox(width: 4),
                FilledButton.tonalIcon(
                  onPressed: () => showUseRecipeSheet(context, recipe),
                  icon: const Icon(Icons.restaurant_outlined, size: 18),
                  label: Text(l10n.useRecipe),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Shared helpers
// ──────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: cs.onSurfaceVariant.withAlpha(128)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<String?> _promptCategoryName(
  BuildContext context, {
  required String title,
  String? initial,
}) {
  final l10n = AppLocalizations.of(context)!;
  final ctrl = TextEditingController(text: initial ?? '');
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: l10n.categoryName,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (v) {
          final name = v.trim();
          if (name.isNotEmpty) Navigator.pop(ctx, name);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = ctrl.text.trim();
            if (name.isNotEmpty) Navigator.pop(ctx, name);
          },
          child: Text(l10n.save),
        ),
      ],
    ),
  ).whenComplete(ctrl.dispose);
}

Future<bool> _confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final cs = Theme.of(context).colorScheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(
            backgroundColor: cs.error,
            foregroundColor: cs.onError,
          ),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  return result ?? false;
}
