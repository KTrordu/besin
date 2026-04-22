import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/nutrition_provider.dart';

class AddEditMealScreen extends StatefulWidget {
  const AddEditMealScreen({super.key, this.meal});

  final Meal? meal;

  @override
  State<AddEditMealScreen> createState() => _AddEditMealScreenState();
}

class _AddEditMealScreenState extends State<AddEditMealScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _caloriesCtrl;
  late final TextEditingController _proteinCtrl;
  late final TextEditingController _carbsCtrl;
  late final TextEditingController _fatCtrl;
  late MealType _selectedType;

  bool get _isEditing => widget.meal != null;

  @override
  void initState() {
    super.initState();
    final m = widget.meal;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _caloriesCtrl = TextEditingController(
        text: m != null ? m.calories.toStringAsFixed(0) : '');
    _proteinCtrl = TextEditingController(
        text: m != null ? m.protein.toStringAsFixed(1) : '');
    _carbsCtrl = TextEditingController(
        text: m != null ? m.carbs.toStringAsFixed(1) : '');
    _fatCtrl = TextEditingController(
        text: m != null ? m.fat.toStringAsFixed(1) : '');
    _selectedType = m?.mealType ?? MealType.breakfast;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<NutritionProvider>();
    final meal = Meal(
      id: widget.meal?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      calories: double.parse(_caloriesCtrl.text),
      protein: double.parse(_proteinCtrl.text),
      carbs: double.parse(_carbsCtrl.text),
      fat: double.parse(_fatCtrl.text),
      timestamp: widget.meal?.timestamp ?? DateTime.now(),
      mealType: _selectedType,
    );
    if (_isEditing) {
      provider.updateMeal(meal);
    } else {
      provider.addMeal(meal);
    }
    Navigator.pop(context);
  }

  void _delete() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Öğünü Sil'),
        content: const Text('Bu öğünü silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
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
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Öğünü Düzenle' : 'Öğün Ekle'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.error,
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildMealTypeSelector(),
            const SizedBox(height: 16),
            Text(
              'Besin Değerleri',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            _buildCaloriesField(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMacroField(_proteinCtrl, 'Protein (g)')),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildMacroField(_carbsCtrl, 'Karbonhidrat (g)')),
                const SizedBox(width: 12),
                Expanded(child: _buildMacroField(_fatCtrl, 'Yağ (g)')),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(_isEditing ? Icons.save_outlined : Icons.add),
              label: Text(_isEditing ? 'Kaydet' : 'Ekle'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameCtrl,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Öğün Adı',
        prefixIcon: Icon(Icons.restaurant_menu_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (v) =>
          v == null || v.trim().isEmpty ? 'Öğün adı boş bırakılamaz' : null,
    );
  }

  Widget _buildMealTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MealType.values.map((type) {
            final selected = _selectedType == type;
            return FilterChip(
              label: Text(type.displayName),
              selected: selected,
              onSelected: (_) => setState(() => _selectedType = type),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCaloriesField() {
    return TextFormField(
      controller: _caloriesCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Kalori (kcal)',
        prefixIcon: Icon(Icons.local_fire_department_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (v) => _validateNumber(v, 'Kalori'),
    );
  }

  Widget _buildMacroField(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (v) => _validateNumber(v, label.split(' ').first),
    );
  }

  String? _validateNumber(String? v, String fieldName) {
    if (v == null || v.trim().isEmpty) return '$fieldName boş bırakılamaz';
    final n = double.tryParse(v.trim());
    if (n == null) return 'Geçerli bir sayı girin';
    if (n < 0) return 'Negatif değer girilemez';
    return null;
  }
}
