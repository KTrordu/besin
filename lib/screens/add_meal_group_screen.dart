import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_l10n_ext.dart';
import '../l10n/app_localizations.dart';
import '../models/meal.dart';
import '../models/saved_food.dart';
import '../providers/food_library_provider.dart';
import '../providers/nutrition_provider.dart';

String _formatNum(double v) =>
    v.toStringAsFixed(1).replaceAll(RegExp(r'\.?0+$'), '');

/// Editor for a named meal group ("öğün"): a meal that contains multiple
/// foods, each with its own nutrition values and serving multiplier. Totals
/// are always recomputed from the items via [Meal.fromItems].
class AddMealGroupScreen extends StatefulWidget {
  const AddMealGroupScreen({super.key, this.meal, this.initialItems, this.initialName});

  /// Non-null when editing an existing group meal.
  final Meal? meal;

  /// Optional pre-filled items (e.g. from a recipe).
  final List<MealItem>? initialItems;
  final String? initialName;

  @override
  State<AddMealGroupScreen> createState() => _AddMealGroupScreenState();
}

class _AddMealGroupScreenState extends State<AddMealGroupScreen> {
  late final TextEditingController _nameCtrl;
  late MealType _selectedType;
  late TimeOfDay _mealTime;
  late List<MealItem> _items;

  bool get _isEditing => widget.meal != null;

  @override
  void initState() {
    super.initState();
    final m = widget.meal;
    _nameCtrl =
        TextEditingController(text: m?.name ?? widget.initialName ?? '');
    _selectedType = m?.mealType ?? MealType.breakfast;
    _mealTime = m?.mealTime ?? TimeOfDay.now();
    _items = List.of(m?.items ?? widget.initialItems ?? const []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  double get _totalCalories =>
      _items.fold(0.0, (s, i) => s + i.calories * i.quantity);
  double get _totalProtein =>
      _items.fold(0.0, (s, i) => s + i.protein * i.quantity);
  double get _totalCarbs =>
      _items.fold(0.0, (s, i) => s + i.carbs * i.quantity);
  double get _totalFat => _items.fold(0.0, (s, i) => s + i.fat * i.quantity);

  Future<void> _addOrEditItem({MealItem? item}) async {
    final result = await showModalBottomSheet<MealItem>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ItemEditorSheet(item: item),
    );
    if (result == null) return;
    setState(() {
      final idx = _items.indexWhere((i) => i.id == result.id);
      if (idx >= 0) {
        _items[idx] = result;
      } else {
        _items.add(result);
      }
    });
  }

  Future<void> _pickFromLibrary() async {
    final food = await showModalBottomSheet<SavedFood>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _FoodPickerSheet(),
    );
    if (food == null) return;
    setState(() {
      _items.add(MealItem(
        id: 'item_${DateTime.now().millisecondsSinceEpoch}',
        name: food.name,
        calories: food.calories,
        protein: food.protein,
        carbs: food.carbs,
        fat: food.fat,
      ));
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.mealNameRequired)));
      return;
    }
    if (_items.isEmpty) return;

    final provider = context.read<NutritionProvider>();
    final meal = Meal.fromItems(
      id: widget.meal?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      items: _items,
      timestamp: widget.meal?.timestamp ?? DateTime.now(),
      mealTime: _mealTime,
      mealType: _selectedType,
    );
    if (_isEditing) {
      await provider.updateMeal(meal);
    } else {
      await provider.addMeal(meal);
    }
    if (mounted) Navigator.pop(context);
  }

  void _delete() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteMealTitle),
        content: Text(l10n.deleteMealConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<NutritionProvider>().deleteMeal(widget.meal!.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final hasFoods =
        context.watch<FoodLibraryProvider>().savedFoods.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editMealGroup : l10n.addMealGroup),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: cs.error,
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.mealGroupName,
              prefixIcon: const Icon(Icons.restaurant_outlined),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.category,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: cs.primary,
                ),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 16),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
              leading:
                  Icon(Icons.access_time_outlined, color: cs.onSurfaceVariant),
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
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(
                  '${(item.calories * item.quantity).toStringAsFixed(0)} kcal'
                  ' · ${l10n.protein.substring(0, 1)} ${_formatNum(item.protein * item.quantity)}'
                  ' · ${l10n.carbs.substring(0, 1)} ${_formatNum(item.carbs * item.quantity)}'
                  ' · ${l10n.fat.substring(0, 1)} ${_formatNum(item.fat * item.quantity)}'
                  '${item.quantity != 1.0 ? '  (×${_formatNum(item.quantity)})' : ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(
                      () => _items.removeWhere((i) => i.id == item.id)),
                ),
                onTap: () => _addOrEditItem(item: item),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addOrEditItem(),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addItem),
                ),
              ),
              if (hasFoods) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromLibrary,
                    icon: const Icon(Icons.star_outline),
                    label: Text(l10n.pickFromFoods),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (_items.isNotEmpty)
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
                      '${_totalCalories.toStringAsFixed(0)} kcal'
                      ' · ${l10n.protein.substring(0, 1)} ${_formatNum(_totalProtein)}'
                      ' · ${l10n.carbs.substring(0, 1)} ${_formatNum(_totalCarbs)}'
                      ' · ${l10n.fat.substring(0, 1)} ${_formatNum(_totalFat)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            onPressed: _items.isEmpty ? null : _save,
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
// Item editor bottom sheet
// ──────────────────────────────────────────────────

class _ItemEditorSheet extends StatefulWidget {
  const _ItemEditorSheet({this.item});

  final MealItem? item;

  @override
  State<_ItemEditorSheet> createState() => _ItemEditorSheetState();
}

class _ItemEditorSheetState extends State<_ItemEditorSheet> {
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
    final i = widget.item;
    _nameCtrl = TextEditingController(text: i?.name ?? '');
    _caloriesCtrl = TextEditingController(
        text: i != null ? _formatNum(i.calories) : '');
    _proteinCtrl =
        TextEditingController(text: i != null ? _formatNum(i.protein) : '');
    _carbsCtrl =
        TextEditingController(text: i != null ? _formatNum(i.carbs) : '');
    _fatCtrl =
        TextEditingController(text: i != null ? _formatNum(i.fat) : '');
    _quantityCtrl = TextEditingController(
        text: i != null ? _formatNum(i.quantity) : '1');
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
    Navigator.pop(
      context,
      MealItem(
        id: widget.item?.id ??
            'item_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameCtrl.text.trim(),
        calories: _parse(_caloriesCtrl),
        protein: _parse(_proteinCtrl),
        carbs: _parse(_carbsCtrl),
        fat: _parse(_fatCtrl),
        quantity: _parse(_quantityCtrl) <= 0 ? 1.0 : _parse(_quantityCtrl),
      ),
    );
  }

  Widget _numField(TextEditingController ctrl, String label,
      {bool required = false}) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
              l10n.addItem,
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
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.mealNameRequired
                  : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _numField(_caloriesCtrl, l10n.caloriesKcal,
                        required: true)),
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
            FilledButton(
              onPressed: _submit,
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Saved food picker bottom sheet
// ──────────────────────────────────────────────────

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
                    leading: const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 20),
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
