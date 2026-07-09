import 'package:flutter/material.dart';

enum MealType { breakfast, lunch, dinner, snack, extra }

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Kahvaltı';
      case MealType.lunch:
        return 'Öğle';
      case MealType.dinner:
        return 'Akşam';
      case MealType.snack:
        return 'Ara Öğün';
      case MealType.extra:
        return 'Atıştırmalık';
    }
  }
}

// One food inside a named meal group. Macro values are per single serving;
// [quantity] is the serving multiplier applied when aggregating the group.
class MealItem {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double quantity;

  const MealItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.quantity = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'quantity': quantity,
      };

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
        id: json['id'] as String,
        name: json['name'] as String,
        calories: (json['calories'] as num).toDouble(),
        protein: (json['protein'] as num?)?.toDouble() ?? 0,
        carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
        fat: (json['fat'] as num?)?.toDouble() ?? 0,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      );

  MealItem copyWith({
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? quantity,
  }) =>
      MealItem(
        id: id,
        name: name ?? this.name,
        calories: calories ?? this.calories,
        protein: protein ?? this.protein,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
        quantity: quantity ?? this.quantity,
      );
}

class Meal {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime timestamp;
  final TimeOfDay mealTime;
  final MealType mealType;
  final bool isFavorite;
  final double quantity;
  final String? barcode;
  final Map<String, double> extraNutrients;

  /// Non-empty means this Meal is a named group ("öğün") of foods. The
  /// stored calories/protein/carbs/fat are the aggregated item totals
  /// (denormalized at save time via [Meal.fromItems]) so every consumer of
  /// meal totals keeps working unchanged.
  final List<MealItem> items;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.timestamp,
    this.mealTime = const TimeOfDay(hour: 12, minute: 0),
    required this.mealType,
    this.isFavorite = false,
    this.quantity = 1.0,
    this.barcode,
    this.extraNutrients = const {},
    this.items = const [],
  });

  /// Single source of truth for building a group meal: totals are always
  /// recomputed from [items] so they can never drift.
  factory Meal.fromItems({
    required String id,
    required String name,
    required List<MealItem> items,
    required DateTime timestamp,
    TimeOfDay mealTime = const TimeOfDay(hour: 12, minute: 0),
    required MealType mealType,
  }) =>
      Meal(
        id: id,
        name: name,
        calories:
            items.fold(0.0, (s, i) => s + i.calories * i.quantity),
        protein: items.fold(0.0, (s, i) => s + i.protein * i.quantity),
        carbs: items.fold(0.0, (s, i) => s + i.carbs * i.quantity),
        fat: items.fold(0.0, (s, i) => s + i.fat * i.quantity),
        timestamp: timestamp,
        mealTime: mealTime,
        mealType: mealType,
        items: items,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'timestamp': timestamp.toIso8601String(),
        'mealTimeHour': mealTime.hour,
        'mealTimeMinute': mealTime.minute,
        'mealType': mealType.index,
        'isFavorite': isFavorite,
        'quantity': quantity,
        'barcode': barcode,
        'extraNutrients': extraNutrients,
        if (items.isNotEmpty)
          'items': items.map((i) => i.toJson()).toList(),
      };

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ts = DateTime.parse(json['timestamp'] as String);
    final TimeOfDay mt;
    if (json['mealTimeHour'] != null) {
      mt = TimeOfDay(
        hour: json['mealTimeHour'] as int,
        minute: (json['mealTimeMinute'] as int?) ?? 0,
      );
    } else {
      // Backward compat: derive from the stored timestamp
      mt = TimeOfDay(hour: ts.hour, minute: ts.minute);
    }
    return Meal(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      timestamp: ts,
      mealTime: mt,
      mealType: MealType.values[json['mealType'] as int],
      isFavorite: json['isFavorite'] as bool? ?? false,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      barcode: json['barcode'] as String?,
      extraNutrients:
          (json['extraNutrients'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, (v as num).toDouble()),
              ) ??
              const {},
      items: (json['items'] as List<dynamic>?)
              ?.map((i) => MealItem.fromJson(i as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Meal copyWith({
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    DateTime? timestamp,
    TimeOfDay? mealTime,
    MealType? mealType,
    bool? isFavorite,
    double? quantity,
    String? barcode,
    Map<String, double>? extraNutrients,
    List<MealItem>? items,
  }) =>
      Meal(
        id: id,
        name: name ?? this.name,
        calories: calories ?? this.calories,
        protein: protein ?? this.protein,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
        timestamp: timestamp ?? this.timestamp,
        mealTime: mealTime ?? this.mealTime,
        mealType: mealType ?? this.mealType,
        isFavorite: isFavorite ?? this.isFavorite,
        quantity: quantity ?? this.quantity,
        barcode: barcode ?? this.barcode,
        extraNutrients: extraNutrients ?? this.extraNutrients,
        items: items ?? this.items,
      );
}
