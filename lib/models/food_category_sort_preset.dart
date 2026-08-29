class FoodCategorySortPreset {
  final String id;
  final String name;
  final List<String> categoryIds;

  const FoodCategorySortPreset({
    required this.id,
    required this.name,
    required this.categoryIds,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'categoryIds': categoryIds,
  };

  factory FoodCategorySortPreset.fromJson(Map<String, dynamic> json) =>
      FoodCategorySortPreset(
        id: json['id'] as String,
        name: json['name'] as String,
        categoryIds: (json['categoryIds'] as List<dynamic>).cast<String>(),
      );
}

enum FoodCategorySortMode { manual, alphabetical, newest, oldest, preset }

class FoodCategorySortSelection {
  final FoodCategorySortMode mode;
  final String? presetId;

  const FoodCategorySortSelection({
    this.mode = FoodCategorySortMode.manual,
    this.presetId,
  });

  Map<String, dynamic> toJson() => {'mode': mode.name, 'presetId': presetId};

  factory FoodCategorySortSelection.fromJson(Map<String, dynamic> json) {
    final name = json['mode'] as String?;
    return FoodCategorySortSelection(
      mode: FoodCategorySortMode.values.firstWhere(
        (value) => value.name == name,
        orElse: () => FoodCategorySortMode.manual,
      ),
      presetId: json['presetId'] as String?,
    );
  }
}
