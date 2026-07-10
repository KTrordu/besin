import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved!'**
  String get saved;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @dashTitle.
  ///
  /// In en, this message translates to:
  /// **'Calorie Tracker'**
  String get dashTitle;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @caloriesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{n} kcal remaining'**
  String caloriesRemaining(String n);

  /// No description provided for @caloriesOver.
  ///
  /// In en, this message translates to:
  /// **'{n} kcal over'**
  String caloriesOver(String n);

  /// No description provided for @macros.
  ///
  /// In en, this message translates to:
  /// **'Macros'**
  String get macros;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @addMeal.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get addMeal;

  /// No description provided for @deleteMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Meal'**
  String get deleteMealTitle;

  /// No description provided for @deleteMealConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this meal?'**
  String get deleteMealConfirm;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{n} Day Streak'**
  String streakDays(int n);

  /// No description provided for @streakDaysWeekly.
  ///
  /// In en, this message translates to:
  /// **'{n} Day Streak 🌟'**
  String streakDaysWeekly(int n);

  /// No description provided for @streakDaysMonthly.
  ///
  /// In en, this message translates to:
  /// **'{n} Day Streak 🏆'**
  String streakDaysMonthly(int n);

  /// No description provided for @streakRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get streakRecord;

  /// No description provided for @streakSubtitleGoalNotMet.
  ///
  /// In en, this message translates to:
  /// **'Meet today\'s goals to keep your streak!'**
  String get streakSubtitleGoalNotMet;

  /// No description provided for @streakSubtitleDay1.
  ///
  /// In en, this message translates to:
  /// **'Great start! Keep going tomorrow!'**
  String get streakSubtitleDay1;

  /// No description provided for @streakSubtitleToWeekly.
  ///
  /// In en, this message translates to:
  /// **'{days} more days — reach weekly streak!'**
  String streakSubtitleToWeekly(int days);

  /// No description provided for @streakSubtitleToMonthly.
  ///
  /// In en, this message translates to:
  /// **'Amazing! {days} more days — monthly streak!'**
  String streakSubtitleToMonthly(int days);

  /// No description provided for @streakSubtitleLegendary.
  ///
  /// In en, this message translates to:
  /// **'You have a legendary streak, keep it up! 🎉'**
  String get streakSubtitleLegendary;

  /// No description provided for @waterTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Tracker'**
  String get waterTitle;

  /// No description provided for @waterGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Daily goal reached! 💧'**
  String get waterGoalReached;

  /// No description provided for @waterRemaining.
  ///
  /// In en, this message translates to:
  /// **'{n} ml remaining'**
  String waterRemaining(int n);

  /// No description provided for @cheatDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today is Cheat Day!'**
  String get cheatDayTitle;

  /// No description provided for @cheatDayBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry about macros today, enjoy! 🎉'**
  String get cheatDayBannerBody;

  /// No description provided for @cheatDay.
  ///
  /// In en, this message translates to:
  /// **'Cheat Day'**
  String get cheatDay;

  /// No description provided for @cheatDayActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Goals and streak are protected'**
  String get cheatDayActiveSubtitle;

  /// No description provided for @cheatDayInactiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a break without breaking your streak'**
  String get cheatDayInactiveSubtitle;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @workoutPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get workoutPush;

  /// No description provided for @workoutPull.
  ///
  /// In en, this message translates to:
  /// **'Pull'**
  String get workoutPull;

  /// No description provided for @workoutLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get workoutLegs;

  /// No description provided for @workoutRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutRest;

  /// No description provided for @workoutNone.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get workoutNone;

  /// No description provided for @workoutLight.
  ///
  /// In en, this message translates to:
  /// **'Light Exercise'**
  String get workoutLight;

  /// No description provided for @workoutUpperBody.
  ///
  /// In en, this message translates to:
  /// **'Upper Body'**
  String get workoutUpperBody;

  /// No description provided for @workoutLowerBody.
  ///
  /// In en, this message translates to:
  /// **'Lower Body'**
  String get workoutLowerBody;

  /// No description provided for @mealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealDinner;

  /// No description provided for @mealSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get mealSnack;

  /// No description provided for @mealExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra'**
  String get mealExtra;

  /// No description provided for @editMeal.
  ///
  /// In en, this message translates to:
  /// **'Edit Meal'**
  String get editMeal;

  /// No description provided for @favoriteMeals.
  ///
  /// In en, this message translates to:
  /// **'Favorite Meals'**
  String get favoriteMeals;

  /// No description provided for @longPressRemove.
  ///
  /// In en, this message translates to:
  /// **'(long press: remove)'**
  String get longPressRemove;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @barcodeSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching product database...'**
  String get barcodeSearching;

  /// No description provided for @barcodeScanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan to auto-fill'**
  String get barcodeScanHint;

  /// No description provided for @barcodeClear.
  ///
  /// In en, this message translates to:
  /// **'Clear barcode'**
  String get barcodeClear;

  /// No description provided for @barcodeRescan.
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get barcodeRescan;

  /// No description provided for @barcodeScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get barcodeScan;

  /// No description provided for @scanRefFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'⭐ Loaded from Favorites: Values are based on the saved portion/quantity (Multiplier: {qty}).'**
  String scanRefFromFavorites(String qty);

  /// No description provided for @scanRefFromApi.
  ///
  /// In en, this message translates to:
  /// **'🌐 API Data: Nutritional values are based on 100g / 100ml reference. Adjust the multiplier accordingly.'**
  String get scanRefFromApi;

  /// No description provided for @scanRefFromServing.
  ///
  /// In en, this message translates to:
  /// **'🌐 API Data: Nutritional values are based on 1 serving ({size}). Adjust the multiplier accordingly.'**
  String scanRefFromServing(String size);

  /// No description provided for @scanRefFromServingGeneric.
  ///
  /// In en, this message translates to:
  /// **'🌐 API Data: Nutritional values are based on 1 serving. Adjust the multiplier accordingly.'**
  String get scanRefFromServingGeneric;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found in database, please enter values manually and add to favorites.'**
  String get productNotFound;

  /// No description provided for @mealName.
  ///
  /// In en, this message translates to:
  /// **'Meal Name'**
  String get mealName;

  /// No description provided for @mealNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Meal name cannot be empty'**
  String get mealNameRequired;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity / Serving'**
  String get quantityLabel;

  /// No description provided for @quantityMultiplied.
  ///
  /// In en, this message translates to:
  /// **'Total values multiplied by {n}x'**
  String quantityMultiplied(String n);

  /// No description provided for @singleServing.
  ///
  /// In en, this message translates to:
  /// **'Single serving'**
  String get singleServing;

  /// No description provided for @mealTime.
  ///
  /// In en, this message translates to:
  /// **'Meal Time'**
  String get mealTime;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @nutritionValues.
  ///
  /// In en, this message translates to:
  /// **'Nutritional Values (1 serving)'**
  String get nutritionValues;

  /// No description provided for @caloriesKcal.
  ///
  /// In en, this message translates to:
  /// **'Calories (kcal)'**
  String get caloriesKcal;

  /// No description provided for @proteinG.
  ///
  /// In en, this message translates to:
  /// **'Protein (g)'**
  String get proteinG;

  /// No description provided for @carbsG.
  ///
  /// In en, this message translates to:
  /// **'Carbs (g)'**
  String get carbsG;

  /// No description provided for @fatG.
  ///
  /// In en, this message translates to:
  /// **'Fat (g)'**
  String get fatG;

  /// No description provided for @extraNutrientG.
  ///
  /// In en, this message translates to:
  /// **'{name} (g)'**
  String extraNutrientG(String name);

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get invalidNumber;

  /// No description provided for @negativeNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Negative values not allowed'**
  String get negativeNotAllowed;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} cannot be empty'**
  String fieldRequired(String field);

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @addToFavoritesSub.
  ///
  /// In en, this message translates to:
  /// **'Save for quick access'**
  String get addToFavoritesSub;

  /// No description provided for @saveToFavoritesOnly.
  ///
  /// In en, this message translates to:
  /// **'Save to Favorites / Template Only'**
  String get saveToFavoritesOnly;

  /// No description provided for @savedAsTemplate.
  ///
  /// In en, this message translates to:
  /// **'Saved to favorites as template'**
  String get savedAsTemplate;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @barcodeFrame.
  ///
  /// In en, this message translates to:
  /// **'Align barcode within frame'**
  String get barcodeFrame;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @dailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get dailyGoals;

  /// No description provided for @calorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Calorie Goal (kcal)'**
  String get calorieGoal;

  /// No description provided for @saveGoals.
  ///
  /// In en, this message translates to:
  /// **'Save Goals'**
  String get saveGoals;

  /// No description provided for @cannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cannot be empty'**
  String get cannotBeEmpty;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get invalidValue;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @startWeight.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startWeight;

  /// No description provided for @currentWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentWeightLabel;

  /// No description provided for @weightChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get weightChange;

  /// No description provided for @todayWeight.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Weight (kg)'**
  String get todayWeight;

  /// No description provided for @invalidWeightValue.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight value'**
  String get invalidWeightValue;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @showWorkoutTracking.
  ///
  /// In en, this message translates to:
  /// **'Show Workout Tracking'**
  String get showWorkoutTracking;

  /// No description provided for @showWorkoutTrackingSub.
  ///
  /// In en, this message translates to:
  /// **'Shows workout selector on Dashboard'**
  String get showWorkoutTrackingSub;

  /// No description provided for @macrosToTrack.
  ///
  /// In en, this message translates to:
  /// **'Macros to Track'**
  String get macrosToTrack;

  /// No description provided for @customNutrients.
  ///
  /// In en, this message translates to:
  /// **'Custom Nutrients'**
  String get customNutrients;

  /// No description provided for @customNutrientsSub.
  ///
  /// In en, this message translates to:
  /// **'Define additional nutrients like Fiber, Sodium'**
  String get customNutrientsSub;

  /// No description provided for @newNutrientHint.
  ///
  /// In en, this message translates to:
  /// **'New nutrient name (e.g.: Fiber)'**
  String get newNutrientHint;

  /// No description provided for @streakRules.
  ///
  /// In en, this message translates to:
  /// **'Streak Rules'**
  String get streakRules;

  /// No description provided for @streakRulesSub.
  ///
  /// In en, this message translates to:
  /// **'Choose which goals must be met and the flexibility margin to maintain your daily streak.'**
  String get streakRulesSub;

  /// No description provided for @streakFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Goal Flexibility: {pct}%'**
  String streakFlexibility(int pct);

  /// No description provided for @calorieGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Calorie Goal'**
  String get calorieGoalLabel;

  /// No description provided for @calorieGoalRequired.
  ///
  /// In en, this message translates to:
  /// **'Calorie goal must be met'**
  String get calorieGoalRequired;

  /// No description provided for @proteinGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein Goal'**
  String get proteinGoalLabel;

  /// No description provided for @proteinGoalRequired.
  ///
  /// In en, this message translates to:
  /// **'Protein goal must be met'**
  String get proteinGoalRequired;

  /// No description provided for @carbsGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs Goal'**
  String get carbsGoalLabel;

  /// No description provided for @carbsGoalRequired.
  ///
  /// In en, this message translates to:
  /// **'Carbs goal must be met'**
  String get carbsGoalRequired;

  /// No description provided for @fatGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat Goal'**
  String get fatGoalLabel;

  /// No description provided for @fatGoalRequired.
  ///
  /// In en, this message translates to:
  /// **'Fat goal must be met'**
  String get fatGoalRequired;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export All Data (CSV)'**
  String get exportCsv;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @calorieHistory.
  ///
  /// In en, this message translates to:
  /// **'Calorie History (14 Days)'**
  String get calorieHistory;

  /// No description provided for @macroHistory.
  ///
  /// In en, this message translates to:
  /// **'Macro History (7 Days)'**
  String get macroHistory;

  /// No description provided for @macroPie.
  ///
  /// In en, this message translates to:
  /// **'Daily Macro Distribution'**
  String get macroPie;

  /// No description provided for @weightTracking.
  ///
  /// In en, this message translates to:
  /// **'Weight Tracking'**
  String get weightTracking;

  /// No description provided for @noWeightData.
  ///
  /// In en, this message translates to:
  /// **'No weight data yet.\nYou can add weight from Settings.'**
  String get noWeightData;

  /// No description provided for @weightDataInsufficient.
  ///
  /// In en, this message translates to:
  /// **'At least 2 measurements needed for chart.'**
  String get weightDataInsufficient;

  /// No description provided for @workoutCorrelation.
  ///
  /// In en, this message translates to:
  /// **'Workout – Macro Correlation (30 Days)'**
  String get workoutCorrelation;

  /// No description provided for @noWorkoutData.
  ///
  /// In en, this message translates to:
  /// **'No workout data.\nSelect workout type from Dashboard.'**
  String get noWorkoutData;

  /// No description provided for @waterStats.
  ///
  /// In en, this message translates to:
  /// **'Water Statistics (30 Days)'**
  String get waterStats;

  /// No description provided for @generalOverview.
  ///
  /// In en, this message translates to:
  /// **'General Overview (30 Days)'**
  String get generalOverview;

  /// No description provided for @noNutritionToday.
  ///
  /// In en, this message translates to:
  /// **'No nutrition logged for today.'**
  String get noNutritionToday;

  /// No description provided for @totalKcal.
  ///
  /// In en, this message translates to:
  /// **'Total: {kcal} kcal'**
  String totalKcal(String kcal);

  /// No description provided for @dailyAvg.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAvg;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @daysMetGoal.
  ///
  /// In en, this message translates to:
  /// **'Days Goal Met'**
  String get daysMetGoal;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @last90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get last90Days;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @avgDailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Avg. Daily Calories'**
  String get avgDailyCalories;

  /// No description provided for @avgDailyProtein.
  ///
  /// In en, this message translates to:
  /// **'Avg. Daily Protein'**
  String get avgDailyProtein;

  /// No description provided for @avgDailyCarbs.
  ///
  /// In en, this message translates to:
  /// **'Avg. Daily Carbs'**
  String get avgDailyCarbs;

  /// No description provided for @avgDailyFat.
  ///
  /// In en, this message translates to:
  /// **'Avg. Daily Fat'**
  String get avgDailyFat;

  /// No description provided for @avgDailyCustom.
  ///
  /// In en, this message translates to:
  /// **'Avg. Daily {name}'**
  String avgDailyCustom(String name);

  /// No description provided for @excludingCheatDays.
  ///
  /// In en, this message translates to:
  /// **'Excluding cheat days'**
  String get excludingCheatDays;

  /// No description provided for @tooltipGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal: {value}'**
  String tooltipGoal(String value);

  /// No description provided for @workoutDays.
  ///
  /// In en, this message translates to:
  /// **'({n} days)'**
  String workoutDays(int n);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{n} days'**
  String daysCount(int n);

  /// No description provided for @waterGoalThreshold.
  ///
  /// In en, this message translates to:
  /// **'≥ 2000 ml / day'**
  String get waterGoalThreshold;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @backupJson.
  ///
  /// In en, this message translates to:
  /// **'Backup (JSON)'**
  String get backupJson;

  /// No description provided for @backupJsonSub.
  ///
  /// In en, this message translates to:
  /// **'Export all data as a JSON backup file'**
  String get backupJsonSub;

  /// No description provided for @restoreJson.
  ///
  /// In en, this message translates to:
  /// **'Restore (JSON)'**
  String get restoreJson;

  /// No description provided for @restoreJsonSub.
  ///
  /// In en, this message translates to:
  /// **'Import data from a JSON backup file'**
  String get restoreJsonSub;

  /// No description provided for @backingUp.
  ///
  /// In en, this message translates to:
  /// **'Backing up...'**
  String get backingUp;

  /// No description provided for @restoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoring;

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup ready — choose where to save or share'**
  String get backupSuccess;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully'**
  String get restoreSuccess;

  /// No description provided for @restoreInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file. Please select a valid Besin backup.'**
  String get restoreInvalidFormat;

  /// No description provided for @restorePickCancelled.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get restorePickCancelled;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailed(String error);

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailed(String error);

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will overwrite all current data with the backup. This cannot be undone.'**
  String get restoreConfirmBody;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// No description provided for @csvDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get csvDate;

  /// No description provided for @csvWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get csvWorkout;

  /// No description provided for @csvCheatDay.
  ///
  /// In en, this message translates to:
  /// **'Cheat Day'**
  String get csvCheatDay;

  /// No description provided for @csvWaterMl.
  ///
  /// In en, this message translates to:
  /// **'Water (ml)'**
  String get csvWaterMl;

  /// No description provided for @csvTotalCalories.
  ///
  /// In en, this message translates to:
  /// **'Total Calories'**
  String get csvTotalCalories;

  /// No description provided for @csvTotalProtein.
  ///
  /// In en, this message translates to:
  /// **'Total Protein (g)'**
  String get csvTotalProtein;

  /// No description provided for @csvTotalCarbs.
  ///
  /// In en, this message translates to:
  /// **'Total Carbs (g)'**
  String get csvTotalCarbs;

  /// No description provided for @csvTotalFat.
  ///
  /// In en, this message translates to:
  /// **'Total Fat (g)'**
  String get csvTotalFat;

  /// No description provided for @csvMealCategory.
  ///
  /// In en, this message translates to:
  /// **'Meal Category'**
  String get csvMealCategory;

  /// No description provided for @csvMealName.
  ///
  /// In en, this message translates to:
  /// **'Meal Name'**
  String get csvMealName;

  /// No description provided for @csvYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get csvYes;

  /// No description provided for @csvNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get csvNo;

  /// No description provided for @navFoods.
  ///
  /// In en, this message translates to:
  /// **'My Foods'**
  String get navFoods;

  /// No description provided for @navWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get navWorkout;

  /// No description provided for @foodsFavoritesTab.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get foodsFavoritesTab;

  /// No description provided for @foodsRecipesTab.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get foodsRecipesTab;

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get categoryGeneral;

  /// No description provided for @categoryBreakfastDefault.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get categoryBreakfastDefault;

  /// No description provided for @categoryProteinDefault.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get categoryProteinDefault;

  /// No description provided for @categorySnacksDefault.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get categorySnacksDefault;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @renameCategory.
  ///
  /// In en, this message translates to:
  /// **'Rename category'**
  String get renameCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Foods in this category will move to General.'**
  String get deleteCategoryConfirm;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @addFood.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get addFood;

  /// No description provided for @editFood.
  ///
  /// In en, this message translates to:
  /// **'Edit food'**
  String get editFood;

  /// No description provided for @deleteFood.
  ///
  /// In en, this message translates to:
  /// **'Delete food'**
  String get deleteFood;

  /// No description provided for @deleteFoodConfirm.
  ///
  /// In en, this message translates to:
  /// **'This food will be removed from your library.'**
  String get deleteFoodConfirm;

  /// No description provided for @noSavedFoods.
  ///
  /// In en, this message translates to:
  /// **'No saved foods yet'**
  String get noSavedFoods;

  /// No description provided for @foodCount.
  ///
  /// In en, this message translates to:
  /// **'{count} foods'**
  String foodCount(int count);

  /// No description provided for @addRecipe.
  ///
  /// In en, this message translates to:
  /// **'Add recipe'**
  String get addRecipe;

  /// No description provided for @editRecipe.
  ///
  /// In en, this message translates to:
  /// **'Edit recipe'**
  String get editRecipe;

  /// No description provided for @deleteRecipe.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe'**
  String get deleteRecipe;

  /// No description provided for @deleteRecipeConfirm.
  ///
  /// In en, this message translates to:
  /// **'This recipe will be deleted.'**
  String get deleteRecipeConfirm;

  /// No description provided for @recipeName.
  ///
  /// In en, this message translates to:
  /// **'Recipe name'**
  String get recipeName;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get addIngredient;

  /// No description provided for @pickFromFoods.
  ///
  /// In en, this message translates to:
  /// **'Pick from my foods'**
  String get pickFromFoods;

  /// No description provided for @useRecipe.
  ///
  /// In en, this message translates to:
  /// **'Use recipe'**
  String get useRecipe;

  /// No description provided for @logRecipe.
  ///
  /// In en, this message translates to:
  /// **'Add to day'**
  String get logRecipe;

  /// No description provided for @recipeTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get recipeTotal;

  /// No description provided for @noRecipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get noRecipes;

  /// No description provided for @ingredientCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ingredients'**
  String ingredientCount(int count);

  /// No description provided for @addMealGroup.
  ///
  /// In en, this message translates to:
  /// **'Add meal'**
  String get addMealGroup;

  /// No description provided for @editMealGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit meal'**
  String get editMealGroup;

  /// No description provided for @mealGroupName.
  ///
  /// In en, this message translates to:
  /// **'Meal name'**
  String get mealGroupName;

  /// No description provided for @mealGroupItems.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String mealGroupItems(int count);

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @quickAddFood.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get quickAddFood;

  /// No description provided for @fromRecipe.
  ///
  /// In en, this message translates to:
  /// **'From recipe'**
  String get fromRecipe;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExercise;

  /// No description provided for @exerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise name'**
  String get exerciseName;

  /// No description provided for @deleteExercise.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get deleteExercise;

  /// No description provided for @deleteExerciseConfirm.
  ///
  /// In en, this message translates to:
  /// **'This exercise and its sets will be deleted.'**
  String get deleteExerciseConfirm;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @addSet.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get addSet;

  /// No description provided for @setSummary.
  ///
  /// In en, this message translates to:
  /// **'{reps} × {kg} kg'**
  String setSummary(int reps, String kg);

  /// No description provided for @noExercisesToday.
  ///
  /// In en, this message translates to:
  /// **'No exercises logged'**
  String get noExercisesToday;

  /// No description provided for @exerciseProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get exerciseProgress;

  /// No description provided for @maxWeightChart.
  ///
  /// In en, this message translates to:
  /// **'Max weight'**
  String get maxWeightChart;

  /// No description provided for @totalVolumeChart.
  ///
  /// In en, this message translates to:
  /// **'Total volume'**
  String get totalVolumeChart;

  /// No description provided for @exerciseHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get exerciseHistory;

  /// No description provided for @notEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet — log this exercise on a few different days.'**
  String get notEnoughData;

  /// No description provided for @savedExercises.
  ///
  /// In en, this message translates to:
  /// **'Saved Exercises'**
  String get savedExercises;

  /// No description provided for @saveExerciseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save exercise'**
  String get saveExerciseTooltip;

  /// No description provided for @unsaveExerciseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get unsaveExerciseTooltip;

  /// No description provided for @exerciseSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Exercise saved'**
  String get exerciseSavedSnack;

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sets'**
  String setsCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
