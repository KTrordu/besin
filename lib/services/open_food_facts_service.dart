import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodProduct {
  final String name;
  final double? caloriesPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatPer100g;

  const FoodProduct({
    required this.name,
    this.caloriesPer100g,
    this.proteinPer100g,
    this.carbsPer100g,
    this.fatPer100g,
  });
}

class OpenFoodFactsService {
  static const _baseUrl = 'https://world.openfoodfacts.org/api/v2/product';
  static const _timeout = Duration(seconds: 10);

  static Future<FoodProduct?> lookupBarcode(String barcode) async {
    try {
      final uri = Uri.parse('$_baseUrl/$barcode.json');
      final response = await http
          .get(uri, headers: {'User-Agent': 'BesinApp/1.0'})
          .timeout(_timeout);

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if ((json['status'] as num?)?.toInt() != 1) return null;

      final product = json['product'] as Map<String, dynamic>?;
      if (product == null) return null;

      final name = (product['product_name'] as String?)?.trim() ?? '';
      if (name.isEmpty) return null;

      final nutriments = product['nutriments'] as Map<String, dynamic>?;

      double? parseNutrient(String key) {
        final v = nutriments?[key];
        return (v as num?)?.toDouble();
      }

      return FoodProduct(
        name: name,
        caloriesPer100g: parseNutrient('energy-kcal_100g'),
        proteinPer100g: parseNutrient('proteins_100g'),
        carbsPer100g: parseNutrient('carbohydrates_100g'),
        fatPer100g: parseNutrient('fat_100g'),
      );
    } catch (_) {
      return null;
    }
  }
}
