import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:kalori_takip/services/open_food_facts_service.dart';

class _MockHttpClient extends Mock implements http.Client {}

Map<String, dynamic> _offJson({
  int status = 1,
  String name = 'Test Product',
  Map<String, dynamic> nutriments = const {},
  String? servingSize,
}) =>
    {
      'status': status,
      'product': {
        'product_name': name,
        'nutriments': nutriments,
        'serving_size': ?servingSize,
      },
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockHttpClient mockClient;
  late OpenFoodFactsService service;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    mockClient = _MockHttpClient();
    service = OpenFoodFactsService(client: mockClient);
  });

  void stubResponse(Map<String, dynamic> body, {int statusCode = 200}) {
    when(() => mockClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(jsonEncode(body), statusCode));
  }

  group('OpenFoodFactsService — lookupBarcode', () {
    // ── a) Perfect 100g data ────────────────────────
    group('a) perfect 100g data', () {
      test('returns BarcodeFound with per100g reference and all values', () async {
        stubResponse(_offJson(nutriments: {
          'energy-kcal_100g': 350.0,
          'proteins_100g': 25.0,
          'carbohydrates_100g': 40.0,
          'fat_100g': 8.0,
        }));

        final result = await service.lookupBarcode('5901234123457');

        expect(result, isA<BarcodeFound>());
        final found = result as BarcodeFound;
        expect(found.product.referenceSize, ReferenceSize.per100g);
        expect(found.product.name, 'Test Product');
        expect(found.product.calories, closeTo(350.0, 0.01));
        expect(found.product.protein, closeTo(25.0, 0.01));
        expect(found.product.carbs, closeTo(40.0, 0.01));
        expect(found.product.fat, closeTo(8.0, 0.01));
        expect(found.product.servingSizeLabel, isNull);
      });
    });

    // ── b) Serving-only data ────────────────────────
    group('b) serving-only data', () {
      test('returns perServing reference when no _100g values exist', () async {
        stubResponse(_offJson(
          nutriments: {
            'energy-kcal_serving': 120.0,
            'proteins_serving': 5.0,
            'carbohydrates_serving': 18.0,
            'fat_serving': 3.0,
          },
          servingSize: '250ml',
        ));

        final result = await service.lookupBarcode('5901234123457');

        expect(result, isA<BarcodeFound>());
        final found = result as BarcodeFound;
        expect(found.product.referenceSize, ReferenceSize.perServing);
        expect(found.product.servingSizeLabel, '250ml');
        expect(found.product.calories, closeTo(120.0, 0.01));
        expect(found.product.protein, closeTo(5.0, 0.01));
        expect(found.product.carbs, closeTo(18.0, 0.01));
        expect(found.product.fat, closeTo(3.0, 0.01));
      });

      test('servingSizeLabel is null when serving_size field is absent', () async {
        stubResponse(_offJson(nutriments: {
          'energy-kcal_serving': 90.0,
          'proteins_serving': 3.0,
        }));

        final result = await service.lookupBarcode('5901234123457');

        expect(result, isA<BarcodeFound>());
        final found = result as BarcodeFound;
        expect(found.product.referenceSize, ReferenceSize.perServing);
        expect(found.product.servingSizeLabel, isNull);
      });
    });

    // ── c) kJ → kcal conversion ─────────────────────
    group('c) kJ to kcal conversion', () {
      test('converts energy_100g (kJ) when energy-kcal_100g is absent', () async {
        const kj = 1674.0; // ≈ 400 kcal
        stubResponse(_offJson(nutriments: {
          'energy_100g': kj,
          'proteins_100g': 20.0,
          'carbohydrates_100g': 50.0,
          'fat_100g': 10.0,
        }));

        final result = await service.lookupBarcode('5901234123457');

        expect(result, isA<BarcodeFound>());
        final found = result as BarcodeFound;
        expect(found.product.referenceSize, ReferenceSize.per100g);
        expect(found.product.calories, closeTo(kj / 4.184, 1.0));
      });

      test('converts energy-kj_100g variant as well', () async {
        const kj = 837.0; // ≈ 200 kcal
        stubResponse(_offJson(nutriments: {
          'energy-kj_100g': kj,
          'proteins_100g': 10.0,
        }));

        final result = await service.lookupBarcode('5901234123457');

        expect(result, isA<BarcodeFound>());
        final found = result as BarcodeFound;
        expect(found.product.calories, closeTo(kj / 4.184, 1.0));
      });
    });

    // ── d) Missing macros ───────────────────────────
    group('d) missing macros', () {
      test('null carbs and fat are assigned 0', () async {
        stubResponse(_offJson(nutriments: {
          'energy-kcal_100g': 200.0,
          'proteins_100g': 15.0,
          // carbohydrates_100g and fat_100g absent
        }));

        final result = await service.lookupBarcode('5901234123457');

        expect(result, isA<BarcodeFound>());
        final found = result as BarcodeFound;
        expect(found.product.protein, closeTo(15.0, 0.01));
        expect(found.product.carbs, 0.0);
        expect(found.product.fat, 0.0);
      });

      test('negative protein is clamped to 0', () async {
        stubResponse(_offJson(nutriments: {
          'energy-kcal_100g': 150.0,
          'proteins_100g': -5.0,
          'carbohydrates_100g': 20.0,
          'fat_100g': 5.0,
        }));

        final result = await service.lookupBarcode('5901234123457');

        expect(result, isA<BarcodeFound>());
        expect((result as BarcodeFound).product.protein, 0.0);
      });
    });

    // ── Value sanitisation ──────────────────────────
    group('value sanitisation', () {
      test('negative calorie value is clamped to 0', () async {
        stubResponse(_offJson(nutriments: {
          'energy-kcal_100g': -50.0,
          'proteins_100g': 10.0,
        }));

        final result = await service.lookupBarcode('5901234123457');
        expect(result, isA<BarcodeFound>());
        expect((result as BarcodeFound).product.calories, 0.0);
      });

      test('calorie value > 10000 is clamped to 0', () async {
        stubResponse(_offJson(nutriments: {
          'energy-kcal_100g': 99999.0,
          'proteins_100g': 10.0,
        }));

        final result = await service.lookupBarcode('5901234123457');
        expect(result, isA<BarcodeFound>());
        expect((result as BarcodeFound).product.calories, 0.0);
      });
    });

    // ── Error handling ──────────────────────────────
    group('error handling', () {
      test('returns BarcodeNotFound when API status != 1', () async {
        stubResponse({'status': 0, 'product': null});

        final result = await service.lookupBarcode('0000000000000');
        expect(result, isA<BarcodeNotFound>());
      });

      test('returns BarcodeNotFound when product name is empty', () async {
        stubResponse(_offJson(name: ''));

        final result = await service.lookupBarcode('5901234123457');
        expect(result, isA<BarcodeNotFound>());
      });

      test('returns BarcodeNotFound when HTTP status != 200', () async {
        stubResponse(_offJson(), statusCode: 404);

        final result = await service.lookupBarcode('5901234123457');
        expect(result, isA<BarcodeNotFound>());
      });

      test('returns BarcodeNetworkError on SocketException', () async {
        when(() => mockClient.get(any(), headers: any(named: 'headers')))
            .thenThrow(const SocketException('no network'));

        final result = await service.lookupBarcode('5901234123457');
        expect(result, isA<BarcodeNetworkError>());
      });

      test('returns BarcodeFound with zeros when no nutriment data is present', () async {
        stubResponse(_offJson(nutriments: {}));

        final result = await service.lookupBarcode('5901234123457');
        expect(result, isA<BarcodeFound>());
        final found = result as BarcodeFound;
        expect(found.product.calories, 0.0);
        expect(found.product.protein, 0.0);
        expect(found.product.referenceSize, ReferenceSize.per100g);
      });
    });
  });
}
