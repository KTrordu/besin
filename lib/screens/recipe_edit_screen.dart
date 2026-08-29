import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/recipe.dart';
import '../models/saved_food.dart';
import '../providers/food_library_provider.dart';
import '../widgets/saved_food_picker_sheet.dart';

String _formatNum(double v) =>
    v.toStringAsFixed(1).replaceAll(RegExp(r'\.?0+$'), '');

/// Create or edit a recipe: a named list of ingredients (snapshots of saved
/// foods, or manually entered) each with a serving multiplier.
class RecipeEditScreen extends StatefulWidget {
  const RecipeEditScreen({super.key, this.recipe});

  final Recipe? recipe;

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  late final TextEditingController _nameCtrl;
  late List<RecipeIngredient> _ingredients;

  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.recipe?.name ?? '');
    _ingredients = List.of(widget.recipe?.ingredients ?? const []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  double get _totalCalories =>
      _ingredients.fold(0.0, (s, i) => s + i.calories * i.quantity);

  Future<void> _pickFromLibrary() async {
    final food = await showModalBottomSheet<SavedFood>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SavedFoodPickerSheet(),
    );
    if (food == null) return;
    setState(() {
      _ingredients.add(
        RecipeIngredient(
          id: 'ing_${DateTime.now().millisecondsSinceEpoch}',
          foodId: food.id,
          name: food.name,
          calories: food.calories,
          protein: food.protein,
          carbs: food.carbs,
          fat: food.fat,
        ),
      );
    });
  }

  Future<void> _addOrEditManual({RecipeIngredient? ingredient}) async {
    final result = await showModalBottomSheet<RecipeIngredient>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _IngredientEditorSheet(ingredient: ingredient),
    );
    if (result == null) return;
    setState(() {
      final idx = _ingredients.indexWhere((i) => i.id == result.id);
      if (idx >= 0) {
        _ingredients[idx] = result;
      } else {
        _ingredients.add(result);
      }
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fieldRequired(l10n.recipeName))),
      );
      return;
    }
    if (_ingredients.isEmpty) return;

    final lib = context.read<FoodLibraryProvider>();
    final recipe = Recipe(
      id: widget.recipe?.id ?? 'rcp_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      ingredients: _ingredients,
      createdAt: widget.recipe?.createdAt ?? DateTime.now(),
    );
    if (_isEditing) {
      await lib.updateRecipe(recipe);
    } else {
      await lib.addRecipe(recipe);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final hasFoods = context.watch<FoodLibraryProvider>().savedFoods.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editRecipe : l10n.addRecipe),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.recipeName,
              prefixIcon: const Icon(Icons.menu_book_outlined),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.list_alt_outlined, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                l10n.ingredients,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final ing in _ingredients)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(ing.name),
                subtitle: Text(
                  '${(ing.calories * ing.quantity).toStringAsFixed(0)} kcal'
                  '${ing.quantity != 1.0 ? '  (×${_formatNum(ing.quantity)})' : ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(
                    () => _ingredients.removeWhere((i) => i.id == ing.id),
                  ),
                ),
                onTap: () => _addOrEditManual(ingredient: ing),
              ),
            ),
          Row(
            children: [
              if (hasFoods)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromLibrary,
                    icon: const Icon(Icons.star_outline),
                    label: Text(l10n.pickFromFoods),
                  ),
                ),
              if (hasFoods) const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addOrEditManual(),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addIngredient),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_ingredients.isNotEmpty)
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${_totalCalories.toStringAsFixed(0)} kcal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _ingredients.isEmpty ? null : _save,
            icon: Icon(_isEditing ? Icons.save_outlined : Icons.add),
            label: Text(_isEditing ? l10n.save : l10n.add),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Manual ingredient editor sheet
// ──────────────────────────────────────────────────

class _IngredientEditorSheet extends StatefulWidget {
  const _IngredientEditorSheet({this.ingredient});

  final RecipeIngredient? ingredient;

  @override
  State<_IngredientEditorSheet> createState() => _IngredientEditorSheetState();
}

class _IngredientEditorSheetState extends State<_IngredientEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _caloriesCtrl;
  late final TextEditingController _proteinCtrl;
  late final TextEditingController _carbsCtrl;
  late final TextEditingController _fatCtrl;
  late final TextEditingController _quantityCtrl;

  @override
  void initState() {
    super.initState();
    final i = widget.ingredient;
    _nameCtrl = TextEditingController(text: i?.name ?? '');
    _caloriesCtrl = TextEditingController(
      text: i != null ? _formatNum(i.calories) : '',
    );
    _proteinCtrl = TextEditingController(
      text: i != null ? _formatNum(i.protein) : '',
    );
    _carbsCtrl = TextEditingController(
      text: i != null ? _formatNum(i.carbs) : '',
    );
    _fatCtrl = TextEditingController(text: i != null ? _formatNum(i.fat) : '');
    _quantityCtrl = TextEditingController(
      text: i != null ? _formatNum(i.quantity) : '1',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  double _parse(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final qty = _parse(_quantityCtrl);
    Navigator.pop(
      context,
      RecipeIngredient(
        id:
            widget.ingredient?.id ??
            'ing_${DateTime.now().millisecondsSinceEpoch}',
        foodId: widget.ingredient?.foodId,
        name: _nameCtrl.text.trim(),
        calories: _parse(_caloriesCtrl),
        protein: _parse(_proteinCtrl),
        carbs: _parse(_carbsCtrl),
        fat: _parse(_fatCtrl),
        quantity: qty <= 0 ? 1.0 : qty,
      ),
    );
  }

  Widget _numField(
    TextEditingController ctrl,
    String label, {
    bool required = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return required ? l10n.fieldRequired(label) : null;
        }
        final n = double.tryParse(v.trim().replaceAll(',', '.'));
        if (n == null) return l10n.invalidNumber;
        if (n < 0) return l10n.negativeNotAllowed;
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.addIngredient,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.mealName,
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l10n.mealNameRequired : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _numField(
                    _caloriesCtrl,
                    l10n.caloriesKcal,
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _numField(_quantityCtrl, l10n.quantityLabel)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _numField(_proteinCtrl, l10n.proteinG)),
                const SizedBox(width: 12),
                Expanded(child: _numField(_carbsCtrl, l10n.carbsG)),
                const SizedBox(width: 12),
                Expanded(child: _numField(_fatCtrl, l10n.fatG)),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _submit, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Saved food picker sheet
// ──────────────────────────────────────────────────

// ignore: unused_element
class _FoodPickerSheet extends StatelessWidget {
  const _FoodPickerSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final foods = context.watch<FoodLibraryProvider>().savedFoods;
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
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.pickFromFoods,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final f = foods[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 20,
                    ),
                    title: Text(f.name),
                    subtitle: Text('${f.calories.toStringAsFixed(0)} kcal'),
                    onTap: () => Navigator.pop(context, f),
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
