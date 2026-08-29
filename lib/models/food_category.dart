// A user-manageable category in the food library. Default categories ship
// with a [builtinKey] and a null [name]; their display name is resolved from
// localizations at render time so they follow the device locale until the
// user renames them (which fills [name], taking precedence).
class FoodCategory {
  final String id;

  /// 'breakfast' | 'protein' | 'snacks' for shipped defaults, null otherwise.
  final String? builtinKey;

  /// User-entered name; null while an un-renamed default.
  final String? name;
  final int sortOrder;
  final int createdAtMillis;

  const FoodCategory({
    required this.id,
    this.builtinKey,
    this.name,
    this.sortOrder = 0,
    this.createdAtMillis = 0,
  });

  static const builtinBreakfast = 'breakfast';
  static const builtinProtein = 'protein';
  static const builtinSnacks = 'snacks';

  /// Categories seeded on first run (before any user customization).
  /// Growable — the provider mutates this list on add/rename/delete.
  static List<FoodCategory> defaults() => [
    FoodCategory(
      id: 'cat_breakfast',
      builtinKey: builtinBreakfast,
      createdAtMillis: 1,
    ),
    FoodCategory(
      id: 'cat_protein',
      builtinKey: builtinProtein,
      sortOrder: 1,
      createdAtMillis: 2,
    ),
    FoodCategory(
      id: 'cat_snacks',
      builtinKey: builtinSnacks,
      sortOrder: 2,
      createdAtMillis: 3,
    ),
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'builtinKey': builtinKey,
    'name': name,
    'sortOrder': sortOrder,
    'createdAtMillis': createdAtMillis,
  };

  factory FoodCategory.fromJson(Map<String, dynamic> json) => FoodCategory(
    id: json['id'] as String,
    builtinKey: json['builtinKey'] as String?,
    name: json['name'] as String?,
    sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    createdAtMillis:
        (json['createdAtMillis'] as num?)?.toInt() ??
        _legacyCreatedAtMillis(json['id'] as String),
  );

  static int _legacyCreatedAtMillis(String id) {
    final timestamp = int.tryParse(id.replaceFirst('cat_', ''));
    return timestamp ?? 0;
  }

  FoodCategory copyWith({String? name, int? sortOrder}) => FoodCategory(
    id: id,
    builtinKey: builtinKey,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAtMillis: createdAtMillis,
  );
}
