import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_l10n_ext.dart';
import '../l10n/app_localizations.dart';
import '../models/meal.dart';
import '../models/recipe.dart';
import '../providers/nutrition_provider.dart';

String _formatNum(double v) =>
    v.toStringAsFixed(1).replaceAll(RegExp(r'\.?0+$'), '');

/// Shows [UseRecipeSheet] and logs the result to the selected day.
Future<void> showUseRecipeSheet(BuildContext context, Recipe recipe) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => UseRecipeSheet(recipe: recipe),
  );
}

/// Logs a recipe as a single group meal. Every ingredient comes in with an
/// editable serving multiplier so portions can be adjusted before saving;
/// totals update live.
class UseRecipeSheet extends StatefulWidget {
  const UseRecipeSheet({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<UseRecipeSheet> createState() => _UseRecipeSheetState();
}

class _UseRecipeSheetState extends State<UseRecipeSheet> {
  late final List<TextEditingController> _qtyCtrls;
  MealType _selectedType = MealType.breakfast;
  TimeOfDay _mealTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _qtyCtrls = [
      for (final ing in widget.recipe.ingredients)
        TextEditingController(text: _formatNum(ing.quantity)),
    ];
    for (final c in _qtyCtrls) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _qtyCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  double _qtyAt(int i) {
    final v = double.tryParse(_qtyCtrls[i].text.trim().replaceAll(',', '.'));
    return (v == null || v < 0) ? 0 : v;
  }

  double get _totalCalories {
    var sum = 0.0;
    for (var i = 0; i < widget.recipe.ingredients.length; i++) {
      sum += widget.recipe.ingredients[i].calories * _qtyAt(i);
    }
    return sum;
  }

  double get _totalProtein {
    var sum = 0.0;
    for (var i = 0; i < widget.recipe.ingredients.length; i++) {
      sum += widget.recipe.ingredients[i].protein * _qtyAt(i);
    }
    return sum;
  }

  double get _totalCarbs {
    var sum = 0.0;
    for (var i = 0; i < widget.recipe.ingredients.length; i++) {
      sum += widget.recipe.ingredients[i].carbs * _qtyAt(i);
    }
    return sum;
  }

  double get _totalFat {
    var sum = 0.0;
    for (var i = 0; i < widget.recipe.ingredients.length; i++) {
      sum += widget.recipe.ingredients[i].fat * _qtyAt(i);
    }
    return sum;
  }

  Future<void> _log() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final items = <MealItem>[];
    for (var i = 0; i < widget.recipe.ingredients.length; i++) {
      final qty = _qtyAt(i);
      if (qty <= 0) continue;
      final ing = widget.recipe.ingredients[i];
      items.add(MealItem(
        id: 'item_${now}_$i',
        name: ing.name,
        calories: ing.calories,
        protein: ing.protein,
        carbs: ing.carbs,
        fat: ing.fat,
        quantity: qty,
      ));
    }
    if (items.isEmpty) return;

    final meal = Meal.fromItems(
      id: now.toString(),
      name: widget.recipe.name,
      items: items,
      timestamp: DateTime.now(),
      mealTime: _mealTime,
      mealType: _selectedType,
    );
    await context.read<NutritionProvider>().addMeal(meal);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final recipe = widget.recipe;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book_outlined, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recipe.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.useRecipe,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MealType.values.map((type) {
                  return FilterChip(
                    label: Text(type.l10nName(l10n)),
                    selected: _selectedType == type,
                    onSelected: (_) => setState(() => _selectedType = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                  leading: Icon(Icons.access_time_outlined,
                      color: cs.onSurfaceVariant),
                  title: Text(l10n.mealTime),
                  trailing: Text(
                    '${_mealTime.hour.toString().padLeft(2, '0')}:${_mealTime.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _mealTime,
                      helpText: l10n.selectTime,
                    );
                    if (picked != null && mounted) {
                      setState(() => _mealTime = picked);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.ingredients,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: cs.primary,
                    ),
              ),
              const SizedBox(height: 8),
              for (var i = 0; i < recipe.ingredients.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(recipe.ingredients[i].name),
                            Text(
                              '${(recipe.ingredients[i].calories * _qtyAt(i)).toStringAsFixed(0)} kcal',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 96,
                        child: TextField(
                          controller: _qtyCtrls[i],
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: l10n.quantityLabel,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                color: cs.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.recipeTotal,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: cs.onPrimaryContainer,
                                ),
                      ),
                      Text(
                        '${_totalCalories.toStringAsFixed(0)} kcal'
                        ' · ${l10n.protein.substring(0, 1)} ${_formatNum(_totalProtein)}'
                        ' · ${l10n.carbs.substring(0, 1)} ${_formatNum(_totalCarbs)}'
                        ' · ${l10n.fat.substring(0, 1)} ${_formatNum(_totalFat)}',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: cs.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _totalCalories <= 0 ? null : _log,
                icon: const Icon(Icons.add),
                label: Text(l10n.logRecipe),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
