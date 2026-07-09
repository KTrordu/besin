import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../l10n/app_l10n_ext.dart';
import '../l10n/app_localizations.dart';
import '../models/meal.dart';
import '../models/saved_food.dart';
import '../providers/food_library_provider.dart';
import '../providers/nutrition_provider.dart';
import '../services/open_food_facts_service.dart';

/// Formats a quantity value removing unnecessary trailing zeros.
/// 0.92 → "0.92", 1.50 → "1.5", 2.00 → "2"
String _formatQty(double v) =>
    v.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');

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
  late TextEditingController _quantityCtrl;
  late TimeOfDay _mealTime;
  String? _barcode;
  bool _isSearchingBarcode = false;
  String? _scanReferenceInfo;

  Map<String, double> _extraNutrients = {};
  final Map<String, TextEditingController> _extraCtrl = {};

  bool get _isEditing => widget.meal != null;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

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
    _extraNutrients = Map<String, double>.from(m?.extraNutrients ?? {});
    _mealTime = m?.mealTime ?? TimeOfDay.now();
    _quantityCtrl = TextEditingController(text: '1');
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
    _quantityCtrl.dispose();
    for (final c in _extraCtrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _fillFromFood(SavedFood food, {String? referenceInfo}) {
    setState(() {
      _nameCtrl.text = food.name;
      _caloriesCtrl.text = food.calories.toStringAsFixed(0);
      _proteinCtrl.text = food.protein.toStringAsFixed(1);
      _carbsCtrl.text = food.carbs.toStringAsFixed(1);
      _fatCtrl.text = food.fat.toStringAsFixed(1);
      _quantityCtrl.text = '1';
      _barcode = food.barcode;
      _scanReferenceInfo = referenceInfo;
      _extraNutrients = Map<String, double>.from(food.extraNutrients);
      for (final entry in _extraCtrl.entries) {
        final val = _extraNutrients[entry.key];
        entry.value.text =
            (val != null && val > 0) ? val.toStringAsFixed(1) : '';
      }
    });
  }

  Map<String, double> _collectExtraNutrients(List<String> activeKeys) {
    final result = <String, double>{};
    for (final key in activeKeys) {
      final v = double.tryParse(_extraCtrl[key]?.text.trim() ?? '');
      if (v != null && v > 0) result[key] = v;
    }
    return result;
  }

  Future<void> _scanBarcode() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _BarcodeScanPage()),
    );
    if (code == null || !mounted) return;

    final l10n = _l10n;
    final saved = context.read<FoodLibraryProvider>().savedFoodByBarcode(code);
    if (saved != null) {
      _fillFromFood(
        saved,
        referenceInfo: l10n.scanRefFromFavorites(_formatQty(1)),
      );
      return;
    }

    setState(() {
      _barcode = code;
      _isSearchingBarcode = true;
      _scanReferenceInfo = null;
    });

    final result = await OpenFoodFactsService().lookupBarcode(code);
    if (!mounted) return;

    switch (result) {
      case BarcodeFound(:final product):
        setState(() {
          _nameCtrl.text = product.name;
          _caloriesCtrl.text = product.calories.toStringAsFixed(0);
          _proteinCtrl.text = product.protein.toStringAsFixed(1);
          _carbsCtrl.text = product.carbs.toStringAsFixed(1);
          _fatCtrl.text = product.fat.toStringAsFixed(1);
          _isSearchingBarcode = false;
          _scanReferenceInfo = switch (product.referenceSize) {
            ReferenceSize.per100g => l10n.scanRefFromApi,
            ReferenceSize.perServing =>
              product.servingSizeLabel?.isNotEmpty == true
                  ? l10n.scanRefFromServing(product.servingSizeLabel!)
                  : l10n.scanRefFromServingGeneric,
          };
        });
      case BarcodeNotFound():
        setState(() {
          _isSearchingBarcode = false;
          _scanReferenceInfo = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.productNotFound),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      case BarcodeNetworkError():
        setState(() {
          _isSearchingBarcode = false;
          _scanReferenceInfo = null;
          _barcode = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.networkError),
              duration: const Duration(seconds: 4),
            ),
          );
        }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<NutritionProvider>();

    final baseCalories = double.parse(_caloriesCtrl.text);
    final baseProtein =
        provider.trackProtein ? (double.tryParse(_proteinCtrl.text) ?? 0.0) : 0.0;
    final baseCarbs =
        provider.trackCarbs ? (double.tryParse(_carbsCtrl.text) ?? 0.0) : 0.0;
    final baseFat =
        provider.trackFat ? (double.tryParse(_fatCtrl.text) ?? 0.0) : 0.0;
    final extraNutrients = _collectExtraNutrients(provider.customNutrients);

    final qty = _isEditing
        ? (widget.meal?.quantity ?? 1.0)
        : (double.tryParse(
                _quantityCtrl.text.trim().replaceAll(',', '.')) ??
            1.0);

    final meal = Meal(
      id: widget.meal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      calories: _isEditing ? baseCalories : baseCalories * qty,
      protein: _isEditing ? baseProtein : baseProtein * qty,
      carbs: _isEditing ? baseCarbs : baseCarbs * qty,
      fat: _isEditing ? baseFat : baseFat * qty,
      timestamp: widget.meal?.timestamp ?? DateTime.now(),
      mealTime: _mealTime,
      mealType: _selectedType,
      isFavorite: _addToFavorites,
      quantity: qty,
      barcode: _barcode,
      extraNutrients: extraNutrients,
    );

    if (_isEditing) {
      await provider.updateMeal(meal);
    } else {
      await provider.addMeal(meal);
    }

    if (_addToFavorites && mounted) {
      await context.read<FoodLibraryProvider>().addSavedFood(SavedFood(
            id: 'fav_${DateTime.now().millisecondsSinceEpoch}',
            name: _nameCtrl.text.trim(),
            calories: baseCalories,
            protein: baseProtein,
            carbs: baseCarbs,
            fat: baseFat,
            barcode: _barcode,
            extraNutrients: extraNutrients,
            createdAt: DateTime.now(),
          ));
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _saveToFavoritesOnly() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = _l10n;
    final provider = context.read<NutritionProvider>();
    final extraNutrients = _collectExtraNutrients(provider.customNutrients);
    await context.read<FoodLibraryProvider>().addSavedFood(SavedFood(
          id: 'fav_${DateTime.now().millisecondsSinceEpoch}',
          name: _nameCtrl.text.trim(),
          calories: double.parse(_caloriesCtrl.text),
          protein: provider.trackProtein
              ? (double.tryParse(_proteinCtrl.text) ?? 0.0)
              : 0.0,
          carbs: provider.trackCarbs
              ? (double.tryParse(_carbsCtrl.text) ?? 0.0)
              : 0.0,
          fat: provider.trackFat
              ? (double.tryParse(_fatCtrl.text) ?? 0.0)
              : 0.0,
          barcode: _barcode,
          extraNutrients: extraNutrients,
          createdAt: DateTime.now(),
        ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.savedAsTemplate)),
      );
      Navigator.pop(context);
    }
  }

  void _delete() {
    final l10n = _l10n;
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
    final l10n = _l10n;
    final provider = context.watch<NutritionProvider>();
    final foodLib = context.watch<FoodLibraryProvider>();
    final favorites = foodLib.savedFoods;
    final categoryLabels = <String?, String>{
      null: l10n.categoryGeneral,
      for (final c in foodLib.categories) c.id: c.displayName(l10n),
    };
    final tp = provider.trackProtein;
    final tc = provider.trackCarbs;
    final tf = provider.trackFat;
    final customNutrients = provider.customNutrients;
    final hasMacros = tp || tc || tf;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editMeal : l10n.addMeal),
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
            if (favorites.isNotEmpty) ...[
              _FavoritesBar(
                favorites: favorites,
                categoryLabels: categoryLabels,
                onTap: _fillFromFood,
                onRemove:
                    context.read<FoodLibraryProvider>().deleteSavedFood,
              ),
              const SizedBox(height: 4),
            ],

            _buildBarcodeRow(),
            if (_scanReferenceInfo != null) ...[
              const SizedBox(height: 8),
              _ScanReferenceInfoBanner(message: _scanReferenceInfo!),
            ],
            const SizedBox(height: 12),

            _buildNameField(),
            const SizedBox(height: 16),
            _buildMealTypeSelector(),
            const SizedBox(height: 16),
            _buildMealTimePicker(),
            const SizedBox(height: 16),

            if (!_isEditing) ...[
              _buildQuantityField(),
              const SizedBox(height: 16),
            ],

            if (hasMacros || customNutrients.isNotEmpty) ...[
              Text(
                l10n.nutritionValues,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
            ],

            _buildCaloriesField(),
            const SizedBox(height: 12),

            if (hasMacros) ...[
              _buildMacroRow(tp, tc, tf),
              const SizedBox(height: 12),
            ],

            for (final key in customNutrients) ...[
              _buildExtraNutrientField(key),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 8),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: SwitchListTile(
                value: _addToFavorites,
                onChanged: (v) => setState(() => _addToFavorites = v),
                secondary: Icon(
                  _addToFavorites ? Icons.star_rounded : Icons.star_outline,
                  color: _addToFavorites ? Colors.amber : null,
                ),
                title: Text(l10n.addToFavorites),
                subtitle: Text(l10n.addToFavoritesSub),
              ),
            ),

            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(_isEditing ? Icons.save_outlined : Icons.add),
              label: Text(_isEditing ? l10n.save : l10n.add),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),

            if (!_isEditing) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _saveToFavoritesOnly,
                icon: const Icon(Icons.star_outline),
                label: Text(l10n.saveToFavoritesOnly),
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
    final l10n = _l10n;
    return TextFormField(
      controller: _nameCtrl,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: l10n.mealName,
        prefixIcon: const Icon(Icons.restaurant_menu_outlined),
        border: const OutlineInputBorder(),
      ),
      validator: (v) =>
          v == null || v.trim().isEmpty ? l10n.mealNameRequired : null,
    );
  }

  Widget _buildMealTypeSelector() {
    final l10n = _l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category,
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
              label: Text(type.l10nName(l10n)),
              selected: _selectedType == type,
              onSelected: (_) => setState(() => _selectedType = type),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMealTimePicker() {
    final l10n = _l10n;
    final cs = Theme.of(context).colorScheme;
    final h = _mealTime.hour.toString().padLeft(2, '0');
    final m = _mealTime.minute.toString().padLeft(2, '0');
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
        leading: Icon(Icons.access_time_outlined, color: cs.onSurfaceVariant),
        title: Text(l10n.mealTime),
        trailing: Text(
          '$h:$m',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
        ),
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: _mealTime,
            helpText: l10n.selectTime,
          );
          if (picked != null && mounted) setState(() => _mealTime = picked);
        },
      ),
    );
  }

  Widget _buildQuantityField() {
    final l10n = _l10n;
    final raw = _quantityCtrl.text.replaceAll(',', '.');
    final qty = double.tryParse(raw) ?? 1.0;
    final hint = qty != 1.0
        ? l10n.quantityMultiplied(_formatQty(qty))
        : l10n.singleServing;
    return TextFormField(
      controller: _quantityCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: l10n.quantityLabel,
        prefixIcon: const Icon(Icons.format_list_numbered_outlined),
        border: const OutlineInputBorder(),
        helperText: hint,
      ),
      onChanged: (_) => setState(() {}),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return l10n.fieldRequired(l10n.quantityLabel);
        }
        final n = double.tryParse(v.trim().replaceAll(',', '.'));
        if (n == null) return l10n.invalidNumber;
        if (n <= 0) return l10n.negativeNotAllowed;
        if (n > 999.99) return l10n.invalidValue;
        return null;
      },
    );
  }

  Widget _buildCaloriesField() {
    final l10n = _l10n;
    return TextFormField(
      controller: _caloriesCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: l10n.caloriesKcal,
        prefixIcon: const Icon(Icons.local_fire_department_outlined),
        border: const OutlineInputBorder(),
      ),
      validator: (v) => _validateNumber(v,
          emptyError: l10n.fieldRequired(l10n.calories),
          invalidError: l10n.invalidNumber,
          negativeError: l10n.negativeNotAllowed),
    );
  }

  Widget _buildMacroField(TextEditingController ctrl, String label,
      {required String fieldName}) {
    final l10n = _l10n;
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (v) => _validateNumber(v,
          emptyError: l10n.fieldRequired(fieldName),
          invalidError: l10n.invalidNumber,
          negativeError: l10n.negativeNotAllowed),
    );
  }

  Widget _buildMacroRow(bool tp, bool tc, bool tf) {
    final l10n = _l10n;
    final fields = [
      if (tp) _buildMacroField(_proteinCtrl, l10n.proteinG, fieldName: l10n.protein),
      if (tc) _buildMacroField(_carbsCtrl, l10n.carbsG, fieldName: l10n.carbs),
      if (tf) _buildMacroField(_fatCtrl, l10n.fatG, fieldName: l10n.fat),
    ];
    if (fields.isEmpty) return const SizedBox.shrink();
    final rowChildren = <Widget>[];
    for (int i = 0; i < fields.length; i++) {
      rowChildren.add(Expanded(child: fields[i]));
      if (i < fields.length - 1) rowChildren.add(const SizedBox(width: 12));
    }
    return Row(children: rowChildren);
  }

  Widget _buildExtraNutrientField(String key) {
    final l10n = _l10n;
    return TextFormField(
      controller: _getExtraCtrl(key),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: l10n.extraNutrientG(key),
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return null;
        final n = double.tryParse(v.trim());
        if (n == null || n < 0) return l10n.invalidNumber;
        return null;
      },
    );
  }

  String? _validateNumber(String? v, {
    required String emptyError,
    required String invalidError,
    required String negativeError,
  }) {
    if (v == null || v.trim().isEmpty) return emptyError;
    final n = double.tryParse(v.trim());
    if (n == null) return invalidError;
    if (n < 0) return negativeError;
    return null;
  }

  Widget _buildBarcodeRow() {
    final l10n = _l10n;
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
                  Text(l10n.barcode),
                  Text(
                    _isSearchingBarcode
                        ? l10n.barcodeSearching
                        : _barcode != null
                            ? _barcode!
                            : l10n.barcodeScanHint,
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
                  tooltip: l10n.barcodeClear,
                  onPressed: () => setState(() {
                    _barcode = null;
                    _scanReferenceInfo = null;
                  }),
                ),
              OutlinedButton.icon(
                onPressed: _scanBarcode,
                icon: const Icon(Icons.qr_code_scanner, size: 16),
                label: Text(_barcode != null ? l10n.barcodeRescan : l10n.barcodeScan),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanBarcode),
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
                l10n.barcodeFrame,
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
    required this.categoryLabels,
    required this.onTap,
    required this.onRemove,
  });

  final List<SavedFood> favorites;
  final Map<String?, String> categoryLabels;
  final void Function(SavedFood, {String? referenceInfo}) onTap;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
            const SizedBox(width: 6),
            Text(
              l10n.favoriteMeals,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: cs.primary,
                  ),
            ),
            const SizedBox(width: 4),
            Text(
              l10n.longPressRemove,
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
              final food = favorites[index];
              return _FavoriteChip(
                food: food,
                categoryLabel:
                    categoryLabels[food.categoryId] ?? categoryLabels[null]!,
                onTap: () => onTap(food),
                onLongPress: () => onRemove(food.id),
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
    required this.food,
    required this.categoryLabel,
    required this.onTap,
    required this.onLongPress,
  });

  final SavedFood food;
  final String categoryLabel;
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
                    categoryLabel,
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
              food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onPrimaryContainer,
                  ),
            ),
            const Spacer(),
            Text(
              '${food.calories.toStringAsFixed(0)} kcal',
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
