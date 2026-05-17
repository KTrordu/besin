import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/nutrition_provider.dart';
import '../services/open_food_facts_service.dart';

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
  int _quantity = 1;
  String? _barcode;
  bool _isSearchingBarcode = false;
  String? _scanReferenceInfo;

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
    _barcode = m?.barcode;
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

  void _fillFromFavorite(Meal fav, {String? referenceInfo}) {
    setState(() {
      _nameCtrl.text = fav.name;
      _caloriesCtrl.text = fav.calories.toStringAsFixed(0);
      _proteinCtrl.text = fav.protein.toStringAsFixed(1);
      _carbsCtrl.text = fav.carbs.toStringAsFixed(1);
      _fatCtrl.text = fav.fat.toStringAsFixed(1);
      _selectedType = fav.mealType;
      _quantity = 1;
      _barcode = fav.barcode;
      _scanReferenceInfo = referenceInfo;
    });
  }

  Future<void> _scanBarcode() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _BarcodeScanPage()),
    );
    if (code == null || !mounted) return;

    // 1. Check local favorites first
    final provider = context.read<NutritionProvider>();
    final matches =
        provider.favoriteMeals.where((m) => m.barcode == code).toList();
    if (matches.isNotEmpty) {
      final fav = matches.first;
      final qty = fav.quantity;
      final qtyStr = qty % 1 == 0 ? qty.toStringAsFixed(0) : qty.toStringAsFixed(1);
      _fillFromFavorite(
        fav,
        referenceInfo:
            '⭐ Favorilerden Yüklendi: Bu değerler favoriye eklediğiniz porsiyon/adet (Çarpan: $qtyStr) baz alınarak doldurulmuştur.',
      );
      return;
    }

    // 2. Query Open Food Facts API
    setState(() {
      _barcode = code;
      _isSearchingBarcode = true;
      _scanReferenceInfo = null;
    });

    final product = await OpenFoodFactsService.lookupBarcode(code);
    if (!mounted) return;

    if (product != null) {
      setState(() {
        _nameCtrl.text = product.name;
        if (product.caloriesPer100g != null) {
          _caloriesCtrl.text = product.caloriesPer100g!.toStringAsFixed(0);
        }
        if (product.proteinPer100g != null) {
          _proteinCtrl.text = product.proteinPer100g!.toStringAsFixed(1);
        }
        if (product.carbsPer100g != null) {
          _carbsCtrl.text = product.carbsPer100g!.toStringAsFixed(1);
        }
        if (product.fatPer100g != null) {
          _fatCtrl.text = product.fatPer100g!.toStringAsFixed(1);
        }
        _isSearchingBarcode = false;
        _scanReferenceInfo =
            '🌐 API Verisi: Bu besin değerleri 100g / 100ml referans alınarak doldurulmuştur. Çarpanı buna göre ayarlayın.';
      });
    } else {
      setState(() {
        _isSearchingBarcode = false;
        _scanReferenceInfo = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ürün veritabanında bulunamadı, lütfen değerleri manuel girerek favorilerinize ekleyin.',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<NutritionProvider>();

    final baseCalories = double.parse(_caloriesCtrl.text);
    final baseProtein = double.parse(_proteinCtrl.text);
    final baseCarbs = double.parse(_carbsCtrl.text);
    final baseFat = double.parse(_fatCtrl.text);

    final meal = Meal(
      id: widget.meal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      calories: _isEditing ? baseCalories : baseCalories * _quantity,
      protein: _isEditing ? baseProtein : baseProtein * _quantity,
      carbs: _isEditing ? baseCarbs : baseCarbs * _quantity,
      fat: _isEditing ? baseFat : baseFat * _quantity,
      timestamp: widget.meal?.timestamp ?? DateTime.now(),
      mealType: _selectedType,
      isFavorite: _addToFavorites,
      quantity: _isEditing ? (widget.meal?.quantity ?? 1.0) : _quantity.toDouble(),
      barcode: _barcode,
    );

    if (_isEditing) {
      await provider.updateMeal(meal);
    } else {
      await provider.addMeal(meal);
    }

    if (_addToFavorites) {
      await provider.addToFavorites(Meal(
        id: 'fav_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameCtrl.text.trim(),
        calories: baseCalories,
        protein: baseProtein,
        carbs: baseCarbs,
        fat: baseFat,
        timestamp: DateTime.now(),
        mealType: _selectedType,
        isFavorite: true,
        barcode: _barcode,
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _saveToFavoritesOnly() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<NutritionProvider>();
    await provider.addToFavorites(Meal(
      id: 'fav_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      calories: double.parse(_caloriesCtrl.text),
      protein: double.parse(_proteinCtrl.text),
      carbs: double.parse(_carbsCtrl.text),
      fat: double.parse(_fatCtrl.text),
      timestamp: DateTime.now(),
      mealType: _selectedType,
      isFavorite: true,
      barcode: _barcode,
    ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şablon olarak favorilere eklendi')),
      );
      Navigator.pop(context);
    }
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

            // ── Barkod Tara ──────────────────────
            _buildBarcodeRow(),
            if (_scanReferenceInfo != null) ...[
              const SizedBox(height: 8),
              _ScanReferenceInfoBanner(message: _scanReferenceInfo!),
            ],
            const SizedBox(height: 12),

            // ── Form alanları ────────────────────
            _buildNameField(),
            const SizedBox(height: 16),
            _buildMealTypeSelector(),
            const SizedBox(height: 16),

            // ── Adet / Porsiyon (sadece eklerken) ─
            if (!_isEditing) ...[
              _buildQuantityStepper(),
              const SizedBox(height: 16),
            ],

            Text(
              'Besin Değerleri (1 porsiyon)',
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

            // ── Sadece Favorilere Kaydet ─────────
            if (!_isEditing) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _saveToFavoritesOnly,
                icon: const Icon(Icons.star_outline),
                label: const Text('Sadece Favorilere / Şablona Kaydet'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
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

  Widget _buildQuantityStepper() {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.format_list_numbered_outlined,
                size: 20, color: cs.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Adet / Porsiyon'),
                  Text(
                    _quantity > 1
                        ? 'Toplam değerler ${_quantity}x çarpılır'
                        : 'Tek porsiyon',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_rounded),
              onPressed:
                  _quantity > 1 ? () => setState(() => _quantity--) : null,
            ),
            SizedBox(
              width: 36,
              child: Text(
                '$_quantity',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed:
                  _quantity < 99 ? () => setState(() => _quantity++) : null,
            ),
          ],
        ),
      ),
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

  Widget _buildBarcodeRow() {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.qr_code, size: 20, color: cs.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Barkod'),
                  Text(
                    _isSearchingBarcode
                        ? 'Ürün veritabanında aranıyor...'
                        : _barcode != null
                            ? _barcode!
                            : 'Otomatik doldurmak için tara',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _isSearchingBarcode
                              ? cs.primary
                              : cs.onSurfaceVariant,
                          fontFamily:
                              (_barcode != null && !_isSearchingBarcode)
                                  ? 'monospace'
                                  : null,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (_isSearchingBarcode)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else ...[
              if (_barcode != null)
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  tooltip: 'Barkodu temizle',
                  onPressed: () => setState(() {
                    _barcode = null;
                    _scanReferenceInfo = null;
                  }),
                ),
              OutlinedButton.icon(
                onPressed: _scanBarcode,
                icon: const Icon(Icons.qr_code_scanner, size: 16),
                label: Text(_barcode != null ? 'Yeniden' : 'Tara'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Barkod Referans Bilgi Kutusu
// ──────────────────────────────────────────────────

class _ScanReferenceInfoBanner extends StatelessWidget {
  const _ScanReferenceInfoBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final infoColor = cs.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: infoColor.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: infoColor.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: infoColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: cs.onSurface,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Barkod Tarayıcı Sayfası
// ──────────────────────────────────────────────────

class _BarcodeScanPage extends StatefulWidget {
  const _BarcodeScanPage();

  @override
  State<_BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<_BarcodeScanPage> {
  final _controller = MobileScannerController();
  bool _detected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barkod Tara'),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_detected) return;
              final barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              final code = barcodes.first.rawValue;
              if (code == null || code.isEmpty) return;
              _detected = true;
              Navigator.of(context).pop(code);
            },
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Barkodu çerçeveye getirin',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black87, blurRadius: 8),
                      ],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
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
