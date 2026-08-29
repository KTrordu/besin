// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navToday => 'Today';

  @override
  String get navStats => 'Statistics';

  @override
  String get navSettings => 'Settings';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved!';

  @override
  String get add => 'Add';

  @override
  String get today => 'Today';

  @override
  String get dashTitle => 'Calorie Tracker';

  @override
  String get calories => 'Calories';

  @override
  String caloriesRemaining(String n) {
    return '$n kcal remaining';
  }

  @override
  String caloriesOver(String n) {
    return '$n kcal over';
  }

  @override
  String get macros => 'Macros';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get addMeal => 'Add Meal';

  @override
  String get deleteMealTitle => 'Delete Meal';

  @override
  String get deleteMealConfirm => 'Are you sure you want to delete this meal?';

  @override
  String streakDays(int n) {
    return '$n Day Streak';
  }

  @override
  String streakDaysWeekly(int n) {
    return '$n Day Streak 🌟';
  }

  @override
  String streakDaysMonthly(int n) {
    return '$n Day Streak 🏆';
  }

  @override
  String get streakRecord => 'Record';

  @override
  String get streakSubtitleGoalNotMet =>
      'Meet today\'s goals to keep your streak!';

  @override
  String get streakSubtitleDay1 => 'Great start! Keep going tomorrow!';

  @override
  String streakSubtitleToWeekly(int days) {
    return '$days more days — reach weekly streak!';
  }

  @override
  String streakSubtitleToMonthly(int days) {
    return 'Amazing! $days more days — monthly streak!';
  }

  @override
  String get streakSubtitleLegendary =>
      'You have a legendary streak, keep it up! 🎉';

  @override
  String get waterTitle => 'Water Tracker';

  @override
  String get waterGoalReached => 'Daily goal reached! 💧';

  @override
  String waterRemaining(int n) {
    return '$n ml remaining';
  }

  @override
  String get cheatDayTitle => 'Today is Cheat Day!';

  @override
  String get cheatDayBannerBody => 'Don\'t worry about macros today, enjoy! 🎉';

  @override
  String get cheatDay => 'Cheat Day';

  @override
  String get cheatDayActiveSubtitle => 'Goals and streak are protected';

  @override
  String get cheatDayInactiveSubtitle =>
      'Take a break without breaking your streak';

  @override
  String get workout => 'Workout';

  @override
  String get workoutPush => 'Push';

  @override
  String get workoutPull => 'Pull';

  @override
  String get workoutLegs => 'Legs';

  @override
  String get workoutRest => 'Rest';

  @override
  String get workoutNone => 'Not set';

  @override
  String get workoutLight => 'Light Exercise';

  @override
  String get workoutUpperBody => 'Upper Body';

  @override
  String get workoutLowerBody => 'Lower Body';

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealSnack => 'Snack';

  @override
  String get mealExtra => 'Extra';

  @override
  String get editMeal => 'Edit Meal';

  @override
  String get favoriteMeals => 'Favorite Meals';

  @override
  String get longPressRemove => '(long press: remove)';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeSearching => 'Searching product database...';

  @override
  String get barcodeScanHint => 'Scan to auto-fill';

  @override
  String get barcodeClear => 'Clear barcode';

  @override
  String get barcodeRescan => 'Rescan';

  @override
  String get barcodeScan => 'Scan';

  @override
  String scanRefFromFavorites(String qty) {
    return '⭐ Loaded from Favorites: Values are based on the saved portion/quantity (Multiplier: $qty).';
  }

  @override
  String get scanRefFromApi =>
      '🌐 API Data: Nutritional values are based on 100g / 100ml reference. Adjust the multiplier accordingly.';

  @override
  String scanRefFromServing(String size) {
    return '🌐 API Data: Nutritional values are based on 1 serving ($size). Adjust the multiplier accordingly.';
  }

  @override
  String get scanRefFromServingGeneric =>
      '🌐 API Data: Nutritional values are based on 1 serving. Adjust the multiplier accordingly.';

  @override
  String get productNotFound =>
      'Product not found in database, please enter values manually and add to favorites.';

  @override
  String get mealName => 'Meal Name';

  @override
  String get mealNameRequired => 'Meal name cannot be empty';

  @override
  String get category => 'Category';

  @override
  String get quantityLabel => 'Quantity / Serving';

  @override
  String quantityMultiplied(String n) {
    return 'Total values multiplied by ${n}x';
  }

  @override
  String get singleServing => 'Single serving';

  @override
  String get mealTime => 'Meal Time';

  @override
  String get selectTime => 'Select Time';

  @override
  String get nutritionValues => 'Nutritional Values (1 serving)';

  @override
  String get caloriesKcal => 'Calories (kcal)';

  @override
  String get proteinG => 'Protein (g)';

  @override
  String get carbsG => 'Carbs (g)';

  @override
  String get fatG => 'Fat (g)';

  @override
  String extraNutrientG(String name) {
    return '$name (g)';
  }

  @override
  String get invalidNumber => 'Enter a valid number';

  @override
  String get negativeNotAllowed => 'Negative values not allowed';

  @override
  String fieldRequired(String field) {
    return '$field cannot be empty';
  }

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get addToFavoritesSub => 'Save for quick access';

  @override
  String get saveToFavoritesOnly => 'Save to Favorites / Template Only';

  @override
  String get savedAsTemplate => 'Saved to favorites as template';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get barcodeFrame => 'Align barcode within frame';

  @override
  String get settings => 'Settings';

  @override
  String get dailyGoals => 'Daily Goals';

  @override
  String get calorieGoal => 'Calorie Goal (kcal)';

  @override
  String get saveGoals => 'Save Goals';

  @override
  String get cannotBeEmpty => 'Cannot be empty';

  @override
  String get invalidValue => 'Invalid value';

  @override
  String get currentWeight => 'Current Weight';

  @override
  String get startWeight => 'Start';

  @override
  String get currentWeightLabel => 'Current';

  @override
  String get weightChange => 'Change';

  @override
  String get todayWeight => 'Today\'s Weight (kg)';

  @override
  String get invalidWeightValue => 'Enter a valid weight value';

  @override
  String get appSettings => 'App Settings';

  @override
  String get showWorkoutTracking => 'Show Workout Tracking';

  @override
  String get showWorkoutTrackingSub => 'Shows workout selector on Dashboard';

  @override
  String get macrosToTrack => 'Macros to Track';

  @override
  String get customNutrients => 'Custom Nutrients';

  @override
  String get customNutrientsSub =>
      'Define additional nutrients like Fiber, Sodium';

  @override
  String get newNutrientHint => 'New nutrient name (e.g.: Fiber)';

  @override
  String get streakRules => 'Streak Rules';

  @override
  String get streakRulesSub =>
      'Choose which goals must be met and the flexibility margin to maintain your daily streak.';

  @override
  String streakFlexibility(int pct) {
    return 'Goal Flexibility: $pct%';
  }

  @override
  String get calorieGoalLabel => 'Calorie Goal';

  @override
  String get calorieGoalRequired => 'Calorie goal must be met';

  @override
  String get proteinGoalLabel => 'Protein Goal';

  @override
  String get proteinGoalRequired => 'Protein goal must be met';

  @override
  String get carbsGoalLabel => 'Carbs Goal';

  @override
  String get carbsGoalRequired => 'Carbs goal must be met';

  @override
  String get fatGoalLabel => 'Fat Goal';

  @override
  String get fatGoalRequired => 'Fat goal must be met';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportCsv => 'Export All Data (CSV)';

  @override
  String get exporting => 'Exporting...';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get statsTitle => 'Statistics';

  @override
  String get calorieHistory => 'Calorie History (14 Days)';

  @override
  String get macroHistory => 'Macro History (7 Days)';

  @override
  String get macroPie => 'Daily Macro Distribution';

  @override
  String get weightTracking => 'Weight Tracking';

  @override
  String get noWeightData =>
      'No weight data yet.\nYou can add weight from Settings.';

  @override
  String get weightDataInsufficient =>
      'At least 2 measurements needed for chart.';

  @override
  String get workoutCorrelation => 'Workout – Macro Correlation (30 Days)';

  @override
  String get noWorkoutData =>
      'No workout data.\nSelect workout type from Dashboard.';

  @override
  String get waterStats => 'Water Statistics (30 Days)';

  @override
  String get generalOverview => 'General Overview (30 Days)';

  @override
  String get noNutritionToday => 'No nutrition logged for today.';

  @override
  String totalKcal(String kcal) {
    return 'Total: $kcal kcal';
  }

  @override
  String get dailyAvg => 'Daily Average';

  @override
  String get noData => 'No data';

  @override
  String get daysMetGoal => 'Days Goal Met';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get last90Days => 'Last 90 days';

  @override
  String get allTime => 'All time';

  @override
  String get avgDailyCalories => 'Avg. Daily Calories';

  @override
  String get avgDailyProtein => 'Avg. Daily Protein';

  @override
  String get avgDailyCarbs => 'Avg. Daily Carbs';

  @override
  String get avgDailyFat => 'Avg. Daily Fat';

  @override
  String avgDailyCustom(String name) {
    return 'Avg. Daily $name';
  }

  @override
  String get excludingCheatDays => 'Excluding cheat days';

  @override
  String tooltipGoal(String value) {
    return 'Goal: $value';
  }

  @override
  String workoutDays(int n) {
    return '($n days)';
  }

  @override
  String daysCount(int n) {
    return '$n days';
  }

  @override
  String get waterGoalThreshold => '≥ 2000 ml / day';

  @override
  String get confirm => 'Confirm';

  @override
  String get backupJson => 'Backup (JSON)';

  @override
  String get backupJsonSub => 'Export all data as a JSON backup file';

  @override
  String get restoreJson => 'Restore (JSON)';

  @override
  String get restoreJsonSub => 'Import data from a JSON backup file';

  @override
  String get backingUp => 'Backing up...';

  @override
  String get restoring => 'Restoring...';

  @override
  String get backupSuccess => 'Backup ready — choose where to save or share';

  @override
  String get restoreSuccess => 'Data restored successfully';

  @override
  String get restoreInvalidFormat =>
      'Invalid backup file. Please select a valid Besin backup.';

  @override
  String get restorePickCancelled => 'No file selected';

  @override
  String backupFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get restoreConfirmTitle => 'Restore Backup?';

  @override
  String get restoreConfirmBody =>
      'This will overwrite all current data with the backup. This cannot be undone.';

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';

  @override
  String get csvDate => 'Date';

  @override
  String get csvWorkout => 'Workout';

  @override
  String get csvCheatDay => 'Cheat Day';

  @override
  String get csvWaterMl => 'Water (ml)';

  @override
  String get csvTotalCalories => 'Total Calories';

  @override
  String get csvTotalProtein => 'Total Protein (g)';

  @override
  String get csvTotalCarbs => 'Total Carbs (g)';

  @override
  String get csvTotalFat => 'Total Fat (g)';

  @override
  String get csvMealCategory => 'Meal Category';

  @override
  String get csvMealName => 'Meal Name';

  @override
  String get csvYes => 'Yes';

  @override
  String get csvNo => 'No';

  @override
  String get navFoods => 'My Foods';

  @override
  String get navWorkout => 'Workout';

  @override
  String get foodsFavoritesTab => 'Favorites';

  @override
  String get foodsRecipesTab => 'Recipes';

  @override
  String get categoryGeneral => 'General';

  @override
  String get categoryBreakfastDefault => 'Breakfast';

  @override
  String get categoryProteinDefault => 'Protein';

  @override
  String get categorySnacksDefault => 'Snacks';

  @override
  String get addCategory => 'Add category';

  @override
  String get categoryOrder => 'Category order';

  @override
  String get manualOrder => 'Manual order';

  @override
  String get alphabeticalOrder => 'Alphabetical';

  @override
  String get newestOrder => 'Newest';

  @override
  String get oldestOrder => 'Oldest';

  @override
  String get createSortPreset => 'Create custom order';

  @override
  String get sortPresetName => 'Order name';

  @override
  String get reorderCategories => 'Reorder categories';

  @override
  String get noFoodsInCategory => 'No saved foods in this category';

  @override
  String get renameCategory => 'Rename category';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String get deleteCategoryConfirm =>
      'Foods in this category will move to General.';

  @override
  String get categoryName => 'Category name';

  @override
  String get addFood => 'Add food';

  @override
  String get editFood => 'Edit food';

  @override
  String get deleteFood => 'Delete food';

  @override
  String get deleteFoodConfirm =>
      'This food will be removed from your library.';

  @override
  String get noSavedFoods => 'No saved foods yet';

  @override
  String foodCount(int count) {
    return '$count foods';
  }

  @override
  String get addRecipe => 'Add recipe';

  @override
  String get editRecipe => 'Edit recipe';

  @override
  String get deleteRecipe => 'Delete recipe';

  @override
  String get deleteRecipeConfirm => 'This recipe will be deleted.';

  @override
  String get recipeName => 'Recipe name';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get addIngredient => 'Add ingredient';

  @override
  String get pickFromFoods => 'Pick from my foods';

  @override
  String get useRecipe => 'Use recipe';

  @override
  String get logRecipe => 'Add to day';

  @override
  String get recipeTotal => 'Total';

  @override
  String get noRecipes => 'No recipes yet';

  @override
  String ingredientCount(int count) {
    return '$count ingredients';
  }

  @override
  String get addMealGroup => 'Add meal';

  @override
  String get editMealGroup => 'Edit meal';

  @override
  String get mealGroupName => 'Meal name';

  @override
  String mealGroupItems(int count) {
    return '$count items';
  }

  @override
  String get addItem => 'Add item';

  @override
  String get quickAddFood => 'Add food';

  @override
  String get fromRecipe => 'From recipe';

  @override
  String get addExercise => 'Add exercise';

  @override
  String get exerciseName => 'Exercise name';

  @override
  String get deleteExercise => 'Delete exercise';

  @override
  String get deleteExerciseConfirm =>
      'This exercise and its sets will be deleted.';

  @override
  String get sets => 'Sets';

  @override
  String get reps => 'Reps';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get addSet => 'Add set';

  @override
  String setSummary(int reps, String kg) {
    return '$reps × $kg kg';
  }

  @override
  String get noExercisesToday => 'No exercises logged';

  @override
  String get exerciseProgress => 'Progress';

  @override
  String get maxWeightChart => 'Max weight';

  @override
  String get totalVolumeChart => 'Total volume';

  @override
  String get exerciseHistory => 'History';

  @override
  String get notEnoughData =>
      'Not enough data yet — log this exercise on a few different days.';

  @override
  String get savedExercises => 'Saved Exercises';

  @override
  String get saveExerciseTooltip => 'Save exercise';

  @override
  String get unsaveExerciseTooltip => 'Remove from saved';

  @override
  String get exerciseSavedSnack => 'Exercise saved';

  @override
  String setsCount(int count) {
    return '$count sets';
  }
}
