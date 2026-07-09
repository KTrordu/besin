import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_l10n_ext.dart';
import '../l10n/app_localizations.dart';
import '../models/saved_food.dart';
import '../providers/food_library_provider.dart';
import '../providers/nutrition_provider.dart';

/// Create or edit a library food ("Besinlerim" item) without logging it to
/// a day: name, nutrition per serving, optional category.
class SavedFoodEditScreen extends StatefulWidget {
  const SavedFoodEditScreen({super.key, this.food, this.initialCategoryId});

  final SavedFood? food;
  final String? initialCategoryId;

  @override
  State<SavedFoodEditScreen> createState() => _SavedFoodEditScreenState();
}

class _SavedFoodEditScreenState extends State<SavedFoodEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _caloriesCtrl;
  late final TextEditingController _proteinCtrl;
  late final TextEditingController _carbsCtrl;
  late final TextEditingController _fatCtrl;
  late String? _categoryId;
  final Map<String, TextEditingController> _extraCtrl = {};
  Map<String, double> _extraNutrients = {};

  bool get _isEditing => widget.food != null;

  @override
  void initState() {
    super.initState();
    final f = widget.food;
    _nameCtrl = TextEditingController(text: f?.name ?? '');
    _caloriesCtrl = TextEditingController(
        text: f != null ? f.calories.toStringAsFixed(0) : '');
    _proteinCtrl = TextEditingController(
        text: f != null ? f.protein.toStringAsFixed(1) : '');
    _carbsCtrl = TextEditingController(
        text: f != null ? f.carbs.toStringAsFixed(1) : '');
    _fatCtrl =
        TextEditingController(text: f != null ? f.fat.toStringAsFixed(1) : '');
    _categoryId = f?.categoryId ?? widget.initialCategoryId;
    _extraNutrients = Map<String, double>.from(f?.extraNutrients ?? {});
  }

  TextEditingController _getExtraCtrl(String key) {
    return _extraCtrl.putIfAbsent(key, () {
      final val = _extraNutrients[key];
      return TextEditingController(
        text: (val != null && val > 0) ? val.toStringAsFixed(1) : '',
      );
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    for (final c in _extraCtrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final nutrition = context.read<NutritionProvider>();
    final extras = <String, double>{};
    for (final key in nutrition.customNutrients) {
      final v = double.tryParse(_extraCtrl[key]?.text.trim() ?? '');
      if (v != null && v > 0) extras[key] = v;
    }

    final food = SavedFood(
      id: widget.food?.id ??
          'fav_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      calories: double.parse(_caloriesCtrl.text.trim().replaceAll(',', '.')),
      protein:
          double.tryParse(_proteinCtrl.text.trim().replaceAll(',', '.')) ?? 0,
      carbs:
          double.tryParse(_carbsCtrl.text.trim().replaceAll(',', '.')) ?? 0,
      fat: double.tryParse(_fatCtrl.text.trim().replaceAll(',', '.')) ?? 0,
      barcode: widget.food?.barcode,
      extraNutrients: extras,
      categoryId: _categoryId,
      createdAt: widget.food?.createdAt ?? DateTime.now(),
    );

    final lib = context.read<FoodLibraryProvider>();
    if (_isEditing) {
      await lib.updateSavedFood(food);
    } else {
      await lib.addSavedFood(food);
    }
    if (mounted) Navigator.pop(context);
  }

  String? _validateNumber(String? v, {required bool required}) {
    final l10n = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) {
      return required ? l10n.cannotBeEmpty : null;
    }
    final n = double.tryParse(v.trim().replaceAll(',', '.'));
    if (n == null) return l10n.invalidNumber;
    if (n < 0) return l10n.negativeNotAllowed;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final lib = context.watch<FoodLibraryProvider>();
    final customNutrients = context.watch<NutritionProvider>().customNutrients;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editFood : l10n.addFood),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.mealName,
                prefixIcon: const Icon(Icons.restaurant_menu_outlined),
                border: const OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.mealNameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              initialValue: _categoryId,
              decoration: InputDecoration(
                labelText: l10n.category,
                prefixIcon: const Icon(Icons.folder_outlined),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(l10n.categoryGeneral),
                ),
                for (final c in lib.categories)
                  DropdownMenuItem<String?>(
                    value: c.id,
                    child: Text(c.displayName(l10n)),
                  ),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.nutritionValues,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: cs.primary,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _caloriesCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.caloriesKcal,
                prefixIcon: const Icon(Icons.local_fire_department_outlined),
                border: const OutlineInputBorder(),
              ),
              validator: (v) => _validateNumber(v, required: true),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _proteinCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.proteinG,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    validator: (v) => _validateNumber(v, required: false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _carbsCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.carbsG,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    validator: (v) => _validateNumber(v, required: false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _fatCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.fatG,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    validator: (v) => _validateNumber(v, required: false),
                  ),
                ),
              ],
            ),
            for (final key in customNutrients) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _getExtraCtrl(key),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.extraNutrientG(key),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                ),
                validator: (v) => _validateNumber(v, required: false),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(_isEditing ? Icons.save_outlined : Icons.add),
              label: Text(_isEditing ? l10n.save : l10n.add),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
