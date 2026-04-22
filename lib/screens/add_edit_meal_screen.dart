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
  late bool _addToFavorites;

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
    _addToFavorites = m?.isFavorite ?? false;
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

  void _fillFromFavorite(Meal fav) {
    setState(() {
      _nameCtrl.text = fav.name;
      _caloriesCtrl.text = fav.calories.toStringAsFixed(0);
      _proteinCtrl.text = fav.protein.toStringAsFixed(1);
      _carbsCtrl.text = fav.carbs.toStringAsFixed(1);
      _fatCtrl.text = fav.fat.toStringAsFixed(1);
      _selectedType = fav.mealType;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<NutritionProvider>();
    final meal = Meal(
      id: widget.meal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      calories: double.parse(_caloriesCtrl.text),
      protein: double.parse(_proteinCtrl.text),
      carbs: double.parse(_carbsCtrl.text),
      fat: double.parse(_fatCtrl.text),
      timestamp: widget.meal?.timestamp ?? DateTime.now(),
      mealType: _selectedType,
      isFavorite: _addToFavorites,
    );

    if (_isEditing) {
      await provider.updateMeal(meal);
    } else {
      await provider.addMeal(meal);
    }

    if (_addToFavorites) {
      await provider.addToFavorites(meal);
    }

    if (mounted) Navigator.pop(context);
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
    final favorites = context.watch<NutritionProvider>().favoriteMeals;

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
            // ── Favori Öğünler Çubuğu ───────────
            if (favorites.isNotEmpty) ...[
              _FavoritesBar(
                favorites: favorites,
                onTap: _fillFromFavorite,
                onRemove: context.read<NutritionProvider>().removeFromFavorites,
              ),
              const SizedBox(height: 4),
            ],

            // ── Form alanları ────────────────────
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
            const SizedBox(height: 8),

            // ── Favorilere ekle toggle ───────────
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: SwitchListTile(
                value: _addToFavorites,
                onChanged: (v) => setState(() => _addToFavorites = v),
                secondary: Icon(
                  _addToFavorites ? Icons.star_rounded : Icons.star_outline,
                  color: _addToFavorites ? Colors.amber : null,
                ),
                title: const Text('Favorilere Ekle'),
                subtitle: const Text('Hızlı erişim için kaydet'),
              ),
            ),

            const SizedBox(height: 16),
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

  // ── Form field builders ──────────────────────

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
            return FilterChip(
              label: Text(type.displayName),
              selected: _selectedType == type,
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

// ──────────────────────────────────────────────────
// Favori Öğünler Çubuğu
// ──────────────────────────────────────────────────

class _FavoritesBar extends StatelessWidget {
  const _FavoritesBar({
    required this.favorites,
    required this.onTap,
    required this.onRemove,
  });

  final List<Meal> favorites;
  final ValueChanged<Meal> onTap;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
            const SizedBox(width: 6),
            Text(
              'Favori Öğünler',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: cs.primary,
                  ),
            ),
            const SizedBox(width: 4),
            Text(
              '(uzun bas: kaldır)',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final meal = favorites[index];
              return _FavoriteChip(
                meal: meal,
                onTap: () => onTap(meal),
                onLongPress: () => onRemove(meal.id),
              );
            },
          ),
        ),
        const Divider(height: 20),
      ],
    );
  }
}

class _FavoriteChip extends StatelessWidget {
  const _FavoriteChip({
    required this.meal,
    required this.onTap,
    required this.onLongPress,
  });

  final Meal meal;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 112,
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.primary.withAlpha(60)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    meal.mealType.displayName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.onPrimaryContainer,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              meal.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onPrimaryContainer,
                  ),
            ),
            const Spacer(),
            Text(
              '${meal.calories.toStringAsFixed(0)} kcal',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
