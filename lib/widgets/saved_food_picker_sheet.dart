import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_l10n_ext.dart';
import '../l10n/app_localizations.dart';
import '../models/food_category.dart';
import '../models/saved_food.dart';
import '../providers/food_library_provider.dart';

class SavedFoodPickerSheet extends StatefulWidget {
  const SavedFoodPickerSheet({super.key});

  @override
  State<SavedFoodPickerSheet> createState() => _SavedFoodPickerSheetState();
}

class _SavedFoodPickerSheetState extends State<SavedFoodPickerSheet> {
  FoodCategory? _selectedCategory;
  var _showGeneral = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lib = context.watch<FoodLibraryProvider>();
    final selected = _selectedCategory;
    final foods = _showGeneral
        ? lib.foodsInCategory(null)
        : selected == null
        ? const <SavedFood>[]
        : lib.foodsInCategory(selected.id);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
              child: Row(
                children: [
                  if (selected != null || _showGeneral)
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => setState(() {
                        _selectedCategory = null;
                        _showGeneral = false;
                      }),
                    ),
                  Expanded(
                    child: Text(
                      selected?.displayName(l10n) ??
                          (_showGeneral
                              ? l10n.categoryGeneral
                              : l10n.pickFromFoods),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: selected == null && !_showGeneral
                  ? _CategoryList(
                      categories: lib.sortedCategories(
                        (category) => category.displayName(l10n),
                      ),
                      generalCount: lib.foodsInCategory(null).length,
                      onGeneralTap: () => setState(() => _showGeneral = true),
                      onCategoryTap: (category) =>
                          setState(() => _selectedCategory = category),
                    )
                  : foods.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(l10n.noFoodsInCategory),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: foods.length,
                      itemBuilder: (context, index) {
                        final food = foods[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                          title: Text(food.name),
                          subtitle: Text(
                            '${food.calories.toStringAsFixed(0)} kcal',
                          ),
                          onTap: () => Navigator.pop(context, food),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.categories,
    required this.generalCount,
    required this.onGeneralTap,
    required this.onCategoryTap,
  });

  final List<FoodCategory> categories;
  final int generalCount;
  final VoidCallback onGeneralTap;
  final ValueChanged<FoodCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      shrinkWrap: true,
      children: [
        if (generalCount > 0)
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(l10n.categoryGeneral),
            trailing: Text('$generalCount'),
            onTap: onGeneralTap,
          ),
        for (final category in categories)
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(category.displayName(l10n)),
            trailing: Text(
              '${context.read<FoodLibraryProvider>().foodsInCategory(category.id).length}',
            ),
            onTap: () => onCategoryTap(category),
          ),
      ],
    );
  }
}
