import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

enum ReferenceSize { per100g, perServing }

class FoodProduct {
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final ReferenceSize referenceSize;
  final String? servingSizeLabel;

  const FoodProduct({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.referenceSize,
    this.servingSizeLabel,
  });
}

sealed class BarcodeResult {}

class BarcodeFound extends BarcodeResult {
  final FoodProduct product;
  BarcodeFound(this.product);
}

class BarcodeNotFound extends BarcodeResult {}

class BarcodeNetworkError extends BarcodeResult {}

class OpenFoodFactsService {
  static const _baseUrl = 'https://world.openfoodfacts.org/api/v2/product';
  static const _timeout = Duration(seconds: 10);

  final http.Client _client;

  OpenFoodFactsService({http.Client? client}) : _client = client ?? http.Client();

  Future<BarcodeResult> lookupBarcode(String barcode) async {
    try {
      final uri = Uri.parse('$_baseUrl/$barcode.json');
      final response = await _client
          .get(uri, headers: {'User-Agent': 'BesinApp/1.0'})
          .timeout(_timeout);

      if (response.statusCode != 200) return BarcodeNotFound();

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if ((json['status'] as num?)?.toInt() != 1) return BarcodeNotFound();

      final product = json['product'] as Map<String, dynamic>?;
      if (product == null) return BarcodeNotFound();

      final name = (product['product_name'] as String?)?.trim() ?? '';
      if (name.isEmpty) return BarcodeNotFound();

      final nutriments = product['nutriments'] as Map<String, dynamic>?;

      double? parseNutrient(String key) {
        final v = nutriments?[key];
        return (v as num?)?.toDouble();
      }

      // Clamps calories: negative or > 10000 are treated as 0.
      double safeCalories(double? raw) {
        if (raw == null || raw < 0 || raw > 10000) return 0;
        return raw;
      }

      double safeMacro(double? raw) => (raw == null || raw < 0) ? 0 : raw;

      // ── Priority 1: per-100g values ──────────────
      double? cal100 = parseNutrient('energy-kcal_100g');
      if (cal100 == null) {
        // kJ fallback: energy_100g or energy-kj_100g
        final kj = parseNutrient('energy_100g') ?? parseNutrient('energy-kj_100g');
        if (kj != null) cal100 = kj / 4.184;
      }
      final prot100 = parseNutrient('proteins_100g');
      final carb100 = parseNutrient('carbohydrates_100g');
      final fat100 = parseNutrient('fat_100g');

      if (cal100 != null || prot100 != null || carb100 != null || fat100 != null) {
        return BarcodeFound(FoodProduct(
          name: name,
          calories: safeCalories(cal100),
          protein: safeMacro(prot100),
          carbs: safeMacro(carb100),
          fat: safeMacro(fat100),
          referenceSize: ReferenceSize.per100g,
        ));
      }

      // ── Priority 2: per-serving values ───────────
      double? calServ = parseNutrient('energy-kcal_serving');
      if (calServ == null) {
        final kjServ =
            parseNutrient('energy_serving') ?? parseNutrient('energy-kj_serving');
        if (kjServ != null) calServ = kjServ / 4.184;
      }
      final protServ = parseNutrient('proteins_serving');
      final carbServ = parseNutrient('carbohydrates_serving');
      final fatServ = parseNutrient('fat_serving');

      if (calServ != null || protServ != null || carbServ != null || fatServ != null) {
        final rawLabel = (product['serving_size'] as String?)?.trim();
        return BarcodeFound(FoodProduct(
          name: name,
          calories: safeCalories(calServ),
          protein: safeMacro(protServ),
          carbs: safeMacro(carbServ),
          fat: safeMacro(fatServ),
          referenceSize: ReferenceSize.perServing,
          servingSizeLabel: (rawLabel?.isNotEmpty == true) ? rawLabel : null,
        ));
      }

      // Product name found but no nutriment data at all.
      return BarcodeFound(FoodProduct(
        name: name,
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
        referenceSize: ReferenceSize.per100g,
      ));
    } on SocketException {
      return BarcodeNetworkError();
    } on TimeoutException {
      return BarcodeNetworkError();
    } catch (_) {
      return BarcodeNetworkError();
    }
  }
}
