# Graph Report - kalori_takip  (2026-07-09)

## Corpus Check
- 89 files · ~80,893 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1164 nodes · 1159 edges · 101 communities (64 shown, 37 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 34 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `ca152c73`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 48|Community 48]]
- [[_COMMUNITY_Community 49|Community 49]]
- [[_COMMUNITY_Community 50|Community 50]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 53|Community 53]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 62|Community 62]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 65|Community 65]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 68|Community 68]]
- [[_COMMUNITY_Community 69|Community 69]]
- [[_COMMUNITY_Community 70|Community 70]]
- [[_COMMUNITY_Community 71|Community 71]]
- [[_COMMUNITY_Community 72|Community 72]]
- [[_COMMUNITY_Community 73|Community 73]]
- [[_COMMUNITY_Community 74|Community 74]]
- [[_COMMUNITY_Community 75|Community 75]]
- [[_COMMUNITY_Community 76|Community 76]]
- [[_COMMUNITY_Community 77|Community 77]]
- [[_COMMUNITY_Community 78|Community 78]]
- [[_COMMUNITY_Community 79|Community 79]]
- [[_COMMUNITY_Community 80|Community 80]]
- [[_COMMUNITY_Community 81|Community 81]]
- [[_COMMUNITY_Community 82|Community 82]]
- [[_COMMUNITY_Community 83|Community 83]]
- [[_COMMUNITY_Community 84|Community 84]]
- [[_COMMUNITY_Community 85|Community 85]]
- [[_COMMUNITY_Community 86|Community 86]]
- [[_COMMUNITY_Community 87|Community 87]]
- [[_COMMUNITY_Community 88|Community 88]]
- [[_COMMUNITY_Community 89|Community 89]]
- [[_COMMUNITY_Community 90|Community 90]]
- [[_COMMUNITY_Community 91|Community 91]]
- [[_COMMUNITY_Community 92|Community 92]]
- [[_COMMUNITY_Community 93|Community 93]]
- [[_COMMUNITY_Community 94|Community 94]]
- [[_COMMUNITY_Community 95|Community 95]]
- [[_COMMUNITY_Community 96|Community 96]]
- [[_COMMUNITY_Community 97|Community 97]]
- [[_COMMUNITY_Community 98|Community 98]]
- [[_COMMUNITY_Community 99|Community 99]]
- [[_COMMUNITY_Community 100|Community 100]]

## God Nodes (most connected - your core abstractions)
1. `NutritionProvider (ChangeNotifier)` - 14 edges
2. `NutritionProvider` - 13 edges
3. `DailyLog model` - 11 edges
4. `StorageService (SharedPreferences)` - 10 edges
5. `AppLocalizations (abstract l10n base)` - 10 edges
6. `NutritionProvider (state management)` - 9 edges
7. `AddEditMealScreen` - 8 edges
8. `SettingsScreen` - 8 edges
9. `AppLocalizations (abstract base)` - 8 edges
10. `WindowClassRegistrar` - 7 edges

## Surprising Connections (you probably didn't know these)
- `NutritionProvider (ChangeNotifier)` --references--> `pubspec.yaml Dependencies`  [INFERRED]
  lib/providers/nutrition_provider.dart → pubspec.yaml
- `StorageService (SharedPreferences)` --references--> `pubspec.yaml Dependencies`  [INFERRED]
  lib/services/storage_service.dart → pubspec.yaml
- `JSON Backup/Restore Feature` --references--> `pubspec.yaml Dependencies`  [INFERRED]
  lib/services/storage_service.dart → pubspec.yaml
- `OpenFoodFactsService (Barcode Lookup)` --references--> `pubspec.yaml Dependencies`  [INFERRED]
  lib/services/open_food_facts_service.dart → pubspec.yaml
- `iOS Flutter Export Environment (Shell)` --semantically_similar_to--> `macOS Flutter Export Environment (Shell)`  [INFERRED] [semantically similar]
  ios/Flutter/flutter_export_environment.sh → macos/Flutter/ephemeral/flutter_export_environment.sh

## Hyperedges (group relationships)
- **AppLocalizations base class and per-locale subclasses** — app_localizations_base, app_localizations_en, app_localizations_de, app_localizations_es, app_localizations_fr, app_localizations_pt, app_localizations_tr [EXTRACTED 0.95]
- **Daily streak calculation and display flow** — nutrition_provider_nutrition_provider, daily_log_daily_log, dashboard_screen_streak_banner, nutrition_provider_test_suite [INFERRED 0.85]
- **Cheat day and flexible macro day feature flow** — nutrition_provider_nutrition_provider, daily_log_daily_log, dashboard_screen_cheat_day_toggle, dashboard_screen_flexible_macro_day_toggle, stats_screen_calorie_bar_chart [INFERRED 0.85]

## Communities (101 total, 37 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.04
Nodes (52): AddEditMealScreen, _AddEditMealScreenState, BarcodeFound, BarcodeNetworkError, BarcodeNotFound, _BarcodeScanPage, _BarcodeScanPageState, build (+44 more)

### Community 1 - "Community 1"
Cohesion: 0.03
Nodes (58): add_edit_meal_screen.dart, add_meal_group_screen.dart, build, _CalorieSummaryCard, Card, _CheatDayBanner, _CheatDayToggle, ChoiceChip (+50 more)

### Community 2 - "Community 2"
Cohesion: 0.06
Nodes (49): AddEditMealScreen, _BarcodeScanPage (barcode scanner subpage), _FavoritesBar widget, Android GeneratedPluginRegistrant.java, Android MainActivity (Kotlin), AppLocalizations (abstract l10n base), DailyGoals model, DailyLog model (+41 more)

### Community 3 - "Community 3"
Cohesion: 0.04
Nodes (52): app_localizations_de.dart, app_localizations_en.dart, app_localizations_es.dart, app_localizations_fr.dart, app_localizations_pt.dart, app_localizations_tr.dart, AppLocalizations, AppLocalizationsDe (+44 more)

### Community 4 - "Community 4"
Cohesion: 0.04
Nodes (45): BarChartGroupData, BarTooltipItem, build, _CalorieBarChart, _calorieSectionChanged, Card, Column, _CorrelationRow (+37 more)

### Community 5 - "Community 5"
Cohesion: 0.05
Nodes (40): Android Gradle Wrapper Script (gradlew), build, _InitErrorApp, KaloriTakipApp, main, _MainNavigation, _MainNavigationState, MaterialApp (+32 more)

### Community 6 - "Community 6"
Cohesion: 0.10
Nodes (33): iOS Build CI Workflow (Unsigned IPA), Cheat Day Feature (streak protection), Custom/Extra Nutrients System, kJ to kcal Conversion Fallback, Configurable Streak Threshold (50-100%), WorkoutType/MealType L10n Extensions, AppLocalizations (i18n Base Class), l10n.yaml Config (+25 more)

### Community 7 - "Community 7"
Cohesion: 0.06
Nodes (33): build, _buildGoalField, Card, Column, _csvEscape, _CustomNutrientsCard, dispose, Divider (+25 more)

### Community 8 - "Community 8"
Cohesion: 0.08
Nodes (27): Flutter Dart Project (flutter::DartProject), Windows Flutter CMakeLists.txt, Flutter View Controller (flutter::FlutterViewController), Class: FlutterWindow (Flutter Embedding Host), Flutter Window (CPP), Flutter Window (Header), Generated Plugin Registrant (CC), Generated Plugin Registrant (Header) (+19 more)

### Community 9 - "Community 9"
Cohesion: 0.10
Nodes (22): RegisterPlugins(), OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle(), GetWindowClass() (+14 more)

### Community 10 - "Community 10"
Cohesion: 0.06
Nodes (30): AppLocalizationsEs, avgDailyCustom, backupFailed, caloriesOver, caloriesRemaining, daysCount, exportFailed, extraNutrientG (+22 more)

### Community 11 - "Community 11"
Cohesion: 0.06
Nodes (30): AppLocalizationsDe, avgDailyCustom, backupFailed, caloriesOver, caloriesRemaining, daysCount, exportFailed, extraNutrientG (+22 more)

### Community 12 - "Community 12"
Cohesion: 0.06
Nodes (30): AppLocalizationsEn, avgDailyCustom, backupFailed, caloriesOver, caloriesRemaining, daysCount, exportFailed, extraNutrientG (+22 more)

### Community 13 - "Community 13"
Cohesion: 0.06
Nodes (30): AppLocalizationsFr, avgDailyCustom, backupFailed, caloriesOver, caloriesRemaining, daysCount, exportFailed, extraNutrientG (+22 more)

### Community 14 - "Community 14"
Cohesion: 0.06
Nodes (30): AppLocalizationsPt, avgDailyCustom, backupFailed, caloriesOver, caloriesRemaining, daysCount, exportFailed, extraNutrientG (+22 more)

### Community 15 - "Community 15"
Cohesion: 0.06
Nodes (30): AppLocalizationsTr, avgDailyCustom, backupFailed, caloriesOver, caloriesRemaining, daysCount, exportFailed, extraNutrientG (+22 more)

### Community 16 - "Community 16"
Cohesion: 0.11
Nodes (23): AppLocalizations (abstract base), AppLocalizationsDe, AppLocalizationsEn, AppLocalizationsEs, AppLocalizationsFr, AppLocalizationsPt, AppLocalizationsTr, DailyGoals (+15 more)

### Community 17 - "Community 17"
Cohesion: 0.11
Nodes (7): fl_register_plugins(), main(), my_application_activate(), my_application_new(), _MyApplication, dart_entrypoint_arguments, parent_instance

### Community 18 - "Community 18"
Cohesion: 0.11
Nodes (17): dateKey, main, _meal, MockStorageService, _stubStorage, package:flutter_test/flutter_test.dart, package:kalori_takip/models/daily_log.dart, package:kalori_takip/models/meal.dart (+9 more)

### Community 19 - "Community 19"
Cohesion: 0.11
Nodes (18): _dateKey, DateTime, init, _isDaySuccessful, NutritionProvider, _persistStreak, _recalculateStreak, selectDate (+10 more)

### Community 20 - "Community 20"
Cohesion: 0.10
Nodes (20): applyBackupMap, FormatException, parseKey, StorageService, writeBool, writeStr, dart:convert, dart:io (+12 more)

### Community 21 - "Community 21"
Cohesion: 0.17
Nodes (11): BarcodeFound, BarcodeNetworkError, BarcodeNotFound, FoodProduct, OpenFoodFactsService, safeCalories, safeMacro, dart:async (+3 more)

### Community 22 - "Community 22"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 23 - "Community 23"
Cohesion: 0.20
Nodes (4): FlutterAppDelegate, FlutterImplicitEngineDelegate, AppDelegate, AppDelegate

### Community 24 - "Community 24"
Cohesion: 0.20
Nodes (9): main, _MockHttpClient, stubResponse, package:kalori_takip/services/open_food_facts_service.dart, dart:convert, dart:io, package:flutter_test/flutter_test.dart, package:http/http.dart (+1 more)

### Community 25 - "Community 25"
Cohesion: 0.32
Nodes (8): App Icon Asset (assets/icon.png), Brand Concept: Default Flutter Icon (web/PWA placeholder), Brand Concept: Meal Plate Icon (food tracking visual identity), Web Favicon (favicon.png), PWA Icon 192x192, PWA Icon 512x512, PWA Maskable Icon 192x192, PWA Maskable Icon 512x512

### Community 26 - "Community 26"
Cohesion: 0.29
Nodes (3): RunnerTests, RunnerTests, XCTestCase

### Community 27 - "Community 27"
Cohesion: 0.29
Nodes (6): main, _makeMeal, package:flutter/material.dart, package:flutter_test/flutter_test.dart, package:kalori_takip/models/daily_log.dart, package:kalori_takip/models/meal.dart

### Community 28 - "Community 28"
Cohesion: 0.33
Nodes (5): handle_new_rx_page(), __lldb_init_module(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages., SBDebugger, SBFrame

### Community 29 - "Community 29"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 30 - "Community 30"
Cohesion: 0.20
Nodes (9): main, dart:convert, package:flutter_test/flutter_test.dart, package:kalori_takip/models/exercise_log.dart, package:kalori_takip/models/food_category.dart, package:kalori_takip/models/recipe.dart, package:kalori_takip/models/saved_food.dart, package:kalori_takip/services/storage_service.dart (+1 more)

### Community 31 - "Community 31"
Cohesion: 0.50
Nodes (5): Android Platform Icons (launcher_icon + ic_launcher), App Icon Brand Identity (Food Plate), iOS Platform Icons, macOS Platform Icons, Flutter Default Launcher Icon (ic_launcher)

### Community 32 - "Community 32"
Cohesion: 0.29
Nodes (6): displayName, l10nName, app_localizations.dart, ../models/daily_log.dart, ../models/food_category.dart, ../models/meal.dart

### Community 33 - "Community 33"
Cohesion: 0.40
Nodes (4): images, info, author, version

### Community 34 - "Community 34"
Cohesion: 0.40
Nodes (4): images, info, author, version

### Community 35 - "Community 35"
Cohesion: 0.40
Nodes (4): copyWith, DailyGoals, DailyLog, meal.dart

### Community 36 - "Community 36"
Cohesion: 0.40
Nodes (4): images, info, author, version

### Community 38 - "Community 38"
Cohesion: 0.50
Nodes (4): Brand Concept: Blank White Launch Screen (iOS default), iOS Launch Image @1x, iOS Launch Image @2x, iOS Launch Image @3x

### Community 39 - "Community 39"
Cohesion: 0.40
Nodes (4): copyWith, Meal, MealItem, package:flutter/material.dart

### Community 40 - "Community 40"
Cohesion: 0.67
Nodes (3): Android App build.gradle.kts, Android root build.gradle.kts, Android settings.gradle.kts

### Community 44 - "Community 44"
Cohesion: 0.67
Nodes (3): iOS App Icon Asset Catalog Contents, iOS Launch Image Asset Catalog Contents, iOS Launch Image README

### Community 77 - "Community 77"
Cohesion: 0.06
Nodes (31): build, Card, _CategoryHeader, Center, dispose, _EmptyState, _FavoritesTab, FoodsScreen (+23 more)

### Community 78 - "Community 78"
Cohesion: 0.07
Nodes (28): AddMealGroupScreen, _AddMealGroupScreenState, build, _delete, dispose, FilterChip, _FoodPickerSheet, _formatNum (+20 more)

### Community 79 - "Community 79"
Cohesion: 0.08
Nodes (24): build, dispose, _FoodPickerSheet, _formatNum, _IngredientEditorSheet, _IngredientEditorSheetState, initState, ListTile (+16 more)

### Community 80 - "Community 80"
Cohesion: 0.08
Nodes (23): _AddExerciseSheet, _AddExerciseSheetState, build, Card, dispose, _ExerciseCard, _formatNum, initState (+15 more)

### Community 81 - "Community 81"
Cohesion: 0.11
Nodes (17): build, dispose, FilterChip, _formatNum, initState, _qtyAt, SafeArea, SizedBox (+9 more)

### Community 82 - "Community 82"
Cohesion: 0.12
Nodes (16): build, dispose, _getExtraCtrl, initState, SavedFoodEditScreen, _SavedFoodEditScreenState, Scaffold, SizedBox (+8 more)

### Community 83 - "Community 83"
Cohesion: 0.12
Nodes (15): build, Card, _ChartCard, ExerciseStatsScreen, _ExerciseStatsScreenState, _formatNum, Padding, Scaffold (+7 more)

### Community 84 - "Community 84"
Cohesion: 0.15
Nodes (12): legacyMeal, main, MockStorageService, _stubStorage, package:kalori_takip/providers/food_library_provider.dart, package:flutter_test/flutter_test.dart, package:kalori_takip/models/food_category.dart, package:kalori_takip/models/meal.dart (+4 more)

### Community 85 - "Community 85"
Cohesion: 0.20
Nodes (9): entry, main, MockStorageService, _stubStorage, package:kalori_takip/providers/workout_provider.dart, package:flutter_test/flutter_test.dart, package:kalori_takip/models/exercise_log.dart, package:kalori_takip/services/storage_service.dart (+1 more)

### Community 86 - "Community 86"
Cohesion: 0.22
Nodes (8): _dateKey, DateTime, selectDate, _today, WorkoutProvider, ../models/exercise_log.dart, package:flutter/foundation.dart, ../services/storage_service.dart

### Community 87 - "Community 87"
Cohesion: 0.25
Nodes (7): FoodLibraryProvider, _migrateLegacyFavorites, ../models/food_category.dart, ../models/recipe.dart, ../models/saved_food.dart, package:flutter/foundation.dart, ../services/storage_service.dart

### Community 88 - "Community 88"
Cohesion: 0.25
Nodes (7): build, Card, DateSelector, _isToday, ../l10n/app_localizations.dart, package:flutter/material.dart, package:intl/intl.dart

### Community 89 - "Community 89"
Cohesion: 0.40
Nodes (4): copyWith, ExerciseEntry, ExerciseSet, dart:math

### Community 90 - "Community 90"
Cohesion: 0.40
Nodes (4): buildEntry, main, package:flutter_test/flutter_test.dart, package:kalori_takip/models/exercise_log.dart

### Community 91 - "Community 91"
Cohesion: 0.40
Nodes (4): main, package:flutter/material.dart, package:flutter_test/flutter_test.dart, package:kalori_takip/models/meal.dart

### Community 92 - "Community 92"
Cohesion: 0.40
Nodes (4): buildRecipe, main, package:flutter_test/flutter_test.dart, package:kalori_takip/models/recipe.dart

### Community 93 - "Community 93"
Cohesion: 0.50
Nodes (3): copyWith, Recipe, RecipeIngredient

### Community 94 - "Community 94"
Cohesion: 0.50
Nodes (3): main, package:flutter_test/flutter_test.dart, package:kalori_takip/models/saved_food.dart

## Knowledge Gaps
- **891 isolated node(s):** `PreToolUse`, `allow`, `MainActivity`, `flutter_export_environment.sh script`, `SBFrame` (+886 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `macOS Generated Plugin Registrant (Swift)` connect `Community 8` to `Community 5`?**
  _High betweenness centrality (0.004) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `AppLocalizations (abstract l10n base)` (e.g. with `AppLocalizationsEs (Spanish translations)` and `AppLocalizationsFr (French translations)`) actually correct?**
  _`AppLocalizations (abstract l10n base)` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `PreToolUse`, `allow`, `MainActivity` to the rest of the system?**
  _895 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.03773584905660377 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.03389830508474576 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.05952380952380952 - nodes in this community are weakly interconnected._
- **Should `Community 3` be split into smaller, more focused modules?**
  _Cohesion score 0.03773584905660377 - nodes in this community are weakly interconnected._