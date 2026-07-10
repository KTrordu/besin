// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navToday => 'Aujourd\'hui';

  @override
  String get navStats => 'Statistiques';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get saved => 'Enregistré !';

  @override
  String get add => 'Ajouter';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get dashTitle => 'Suivi Calorique';

  @override
  String get calories => 'Calories';

  @override
  String caloriesRemaining(String n) {
    return '$n kcal restantes';
  }

  @override
  String caloriesOver(String n) {
    return '$n kcal dépassées';
  }

  @override
  String get macros => 'Macros';

  @override
  String get protein => 'Protéines';

  @override
  String get carbs => 'Glucides';

  @override
  String get fat => 'Lipides';

  @override
  String get addMeal => 'Ajouter un repas';

  @override
  String get deleteMealTitle => 'Supprimer le repas';

  @override
  String get deleteMealConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce repas ?';

  @override
  String streakDays(int n) {
    return 'Série de $n jours';
  }

  @override
  String streakDaysWeekly(int n) {
    return 'Série de $n jours 🌟';
  }

  @override
  String streakDaysMonthly(int n) {
    return 'Série de $n jours 🏆';
  }

  @override
  String get streakRecord => 'Record';

  @override
  String get streakSubtitleGoalNotMet =>
      'Atteignez vos objectifs aujourd\'hui pour maintenir votre série !';

  @override
  String get streakSubtitleDay1 => 'Super départ ! Continuez demain !';

  @override
  String streakSubtitleToWeekly(int days) {
    return '$days jours de plus — série hebdomadaire !';
  }

  @override
  String streakSubtitleToMonthly(int days) {
    return 'Incroyable ! $days jours de plus — série mensuelle !';
  }

  @override
  String get streakSubtitleLegendary =>
      'Vous avez une série légendaire, continuez ! 🎉';

  @override
  String get waterTitle => 'Suivi de l\'eau';

  @override
  String get waterGoalReached => 'Objectif quotidien atteint ! 💧';

  @override
  String waterRemaining(int n) {
    return '$n ml restants';
  }

  @override
  String get cheatDayTitle => 'C\'est un Cheat Day !';

  @override
  String get cheatDayBannerBody =>
      'Ne vous souciez pas des macros aujourd\'hui, profitez-en ! 🎉';

  @override
  String get cheatDay => 'Cheat Day';

  @override
  String get cheatDayActiveSubtitle => 'Objectifs et série protégés';

  @override
  String get cheatDayInactiveSubtitle =>
      'Faites une pause sans briser votre série';

  @override
  String get workout => 'Entraînement';

  @override
  String get workoutPush => 'Push';

  @override
  String get workoutPull => 'Pull';

  @override
  String get workoutLegs => 'Jambes';

  @override
  String get workoutRest => 'Repos';

  @override
  String get workoutNone => 'Non défini';

  @override
  String get workoutLight => 'Exercice léger';

  @override
  String get workoutUpperBody => 'Haut du corps';

  @override
  String get workoutLowerBody => 'Bas du corps';

  @override
  String get mealBreakfast => 'Petit-déjeuner';

  @override
  String get mealLunch => 'Déjeuner';

  @override
  String get mealDinner => 'Dîner';

  @override
  String get mealSnack => 'Collation';

  @override
  String get mealExtra => 'Extra';

  @override
  String get editMeal => 'Modifier le repas';

  @override
  String get favoriteMeals => 'Repas favoris';

  @override
  String get longPressRemove => '(appui long : supprimer)';

  @override
  String get barcode => 'Code-barres';

  @override
  String get barcodeSearching => 'Recherche dans la base de données...';

  @override
  String get barcodeScanHint => 'Scanner pour remplir automatiquement';

  @override
  String get barcodeClear => 'Effacer le code-barres';

  @override
  String get barcodeRescan => 'Rescanner';

  @override
  String get barcodeScan => 'Scanner';

  @override
  String scanRefFromFavorites(String qty) {
    return '⭐ Chargé depuis les favoris : Valeurs basées sur la portion/quantité sauvegardée (Multiplicateur : $qty).';
  }

  @override
  String get scanRefFromApi =>
      '🌐 Données API : Valeurs nutritionnelles basées sur 100g / 100ml. Ajustez le multiplicateur en conséquence.';

  @override
  String scanRefFromServing(String size) {
    return '🌐 Données API : Valeurs nutritionnelles basées sur 1 portion ($size). Ajustez le multiplicateur en conséquence.';
  }

  @override
  String get scanRefFromServingGeneric =>
      '🌐 Données API : Valeurs nutritionnelles basées sur 1 portion. Ajustez le multiplicateur en conséquence.';

  @override
  String get productNotFound =>
      'Produit introuvable dans la base de données. Saisissez les valeurs manuellement et ajoutez aux favoris.';

  @override
  String get mealName => 'Nom du repas';

  @override
  String get mealNameRequired => 'Le nom du repas ne peut pas être vide';

  @override
  String get category => 'Catégorie';

  @override
  String get quantityLabel => 'Quantité / Portion';

  @override
  String quantityMultiplied(String n) {
    return 'Valeurs totales multipliées par ${n}x';
  }

  @override
  String get singleServing => 'Portion unique';

  @override
  String get mealTime => 'Heure du repas';

  @override
  String get selectTime => 'Choisir l\'heure';

  @override
  String get nutritionValues => 'Valeurs nutritionnelles (1 portion)';

  @override
  String get caloriesKcal => 'Calories (kcal)';

  @override
  String get proteinG => 'Protéines (g)';

  @override
  String get carbsG => 'Glucides (g)';

  @override
  String get fatG => 'Lipides (g)';

  @override
  String extraNutrientG(String name) {
    return '$name (g)';
  }

  @override
  String get invalidNumber => 'Entrez un nombre valide';

  @override
  String get negativeNotAllowed =>
      'Les valeurs négatives ne sont pas autorisées';

  @override
  String fieldRequired(String field) {
    return '$field ne peut pas être vide';
  }

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get addToFavoritesSub => 'Enregistrer pour un accès rapide';

  @override
  String get saveToFavoritesOnly =>
      'Enregistrer dans les favoris / modèle uniquement';

  @override
  String get savedAsTemplate => 'Enregistré dans les favoris comme modèle';

  @override
  String get scanBarcode => 'Scanner le code-barres';

  @override
  String get barcodeFrame => 'Alignez le code-barres dans le cadre';

  @override
  String get settings => 'Paramètres';

  @override
  String get dailyGoals => 'Objectifs quotidiens';

  @override
  String get calorieGoal => 'Objectif calorique (kcal)';

  @override
  String get saveGoals => 'Enregistrer les objectifs';

  @override
  String get cannotBeEmpty => 'Ne peut pas être vide';

  @override
  String get invalidValue => 'Valeur invalide';

  @override
  String get currentWeight => 'Poids actuel';

  @override
  String get startWeight => 'Départ';

  @override
  String get currentWeightLabel => 'Actuel';

  @override
  String get weightChange => 'Variation';

  @override
  String get todayWeight => 'Poids du jour (kg)';

  @override
  String get invalidWeightValue => 'Entrez une valeur de poids valide';

  @override
  String get appSettings => 'Paramètres de l\'application';

  @override
  String get showWorkoutTracking => 'Afficher le suivi d\'entraînement';

  @override
  String get showWorkoutTrackingSub =>
      'Affiche le sélecteur d\'entraînement sur le tableau de bord';

  @override
  String get macrosToTrack => 'Macros à suivre';

  @override
  String get customNutrients => 'Nutriments personnalisés';

  @override
  String get customNutrientsSub =>
      'Définissez des nutriments supplémentaires comme les fibres, le sodium';

  @override
  String get newNutrientHint => 'Nouveau nutriment (ex : Fibres)';

  @override
  String get streakRules => 'Règles de série';

  @override
  String get streakRulesSub =>
      'Choisissez les objectifs à atteindre et la marge de flexibilité pour maintenir votre série.';

  @override
  String streakFlexibility(int pct) {
    return 'Flexibilité : $pct%';
  }

  @override
  String get calorieGoalLabel => 'Objectif calorique';

  @override
  String get calorieGoalRequired => 'L\'objectif calorique doit être atteint';

  @override
  String get proteinGoalLabel => 'Objectif protéines';

  @override
  String get proteinGoalRequired => 'L\'objectif protéines doit être atteint';

  @override
  String get carbsGoalLabel => 'Objectif glucides';

  @override
  String get carbsGoalRequired => 'L\'objectif glucides doit être atteint';

  @override
  String get fatGoalLabel => 'Objectif lipides';

  @override
  String get fatGoalRequired => 'L\'objectif lipides doit être atteint';

  @override
  String get dataManagement => 'Gestion des données';

  @override
  String get exportCsv => 'Exporter toutes les données (CSV)';

  @override
  String get exporting => 'Exportation en cours...';

  @override
  String exportFailed(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get calorieHistory => 'Historique calorique (14 jours)';

  @override
  String get macroHistory => 'Historique des macros (7 jours)';

  @override
  String get macroPie => 'Répartition des macros du jour';

  @override
  String get weightTracking => 'Suivi du poids';

  @override
  String get noWeightData =>
      'Aucune donnée de poids.\nAjoutez votre poids dans les paramètres.';

  @override
  String get weightDataInsufficient =>
      'Au moins 2 mesures nécessaires pour le graphique.';

  @override
  String get workoutCorrelation =>
      'Entraînement – Corrélation macros (30 jours)';

  @override
  String get noWorkoutData =>
      'Aucune donnée d\'entraînement.\nSélectionnez un type depuis le tableau de bord.';

  @override
  String get waterStats => 'Statistiques eau (30 jours)';

  @override
  String get generalOverview => 'Vue d\'ensemble (30 jours)';

  @override
  String get noNutritionToday => 'Aucun repas enregistré aujourd\'hui.';

  @override
  String totalKcal(String kcal) {
    return 'Total : $kcal kcal';
  }

  @override
  String get dailyAvg => 'Moyenne quotidienne';

  @override
  String get noData => 'Pas de données';

  @override
  String get daysMetGoal => 'Jours avec objectif atteint';

  @override
  String get last30Days => '30 derniers jours';

  @override
  String get last90Days => '90 derniers jours';

  @override
  String get allTime => 'Tout';

  @override
  String get avgDailyCalories => 'Moy. calories / jour';

  @override
  String get avgDailyProtein => 'Moy. protéines / jour';

  @override
  String get avgDailyCarbs => 'Moy. glucides / jour';

  @override
  String get avgDailyFat => 'Moy. lipides / jour';

  @override
  String avgDailyCustom(String name) {
    return 'Moy. $name / jour';
  }

  @override
  String get excludingCheatDays => 'Cheat days exclus';

  @override
  String tooltipGoal(String value) {
    return 'Objectif : $value';
  }

  @override
  String workoutDays(int n) {
    return '($n jours)';
  }

  @override
  String daysCount(int n) {
    return '$n jours';
  }

  @override
  String get waterGoalThreshold => '≥ 2000 ml / jour';

  @override
  String get confirm => 'Confirmer';

  @override
  String get backupJson => 'Sauvegarder (JSON)';

  @override
  String get backupJsonSub => 'Exporter toutes les données en fichier JSON';

  @override
  String get restoreJson => 'Restaurer (JSON)';

  @override
  String get restoreJsonSub =>
      'Importer des données depuis un fichier de sauvegarde JSON';

  @override
  String get backingUp => 'Sauvegarde en cours...';

  @override
  String get restoring => 'Restauration en cours...';

  @override
  String get backupSuccess =>
      'Sauvegarde prête — choisissez où enregistrer ou partager';

  @override
  String get restoreSuccess => 'Données restaurées avec succès';

  @override
  String get restoreInvalidFormat =>
      'Fichier de sauvegarde invalide. Sélectionnez une sauvegarde Besin valide.';

  @override
  String get restorePickCancelled => 'Aucun fichier sélectionné';

  @override
  String backupFailed(String error) {
    return 'Échec de la sauvegarde : $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Échec de la restauration : $error';
  }

  @override
  String get restoreConfirmTitle => 'Restaurer la sauvegarde ?';

  @override
  String get restoreConfirmBody =>
      'Cela écrasera toutes les données actuelles. Cette action est irréversible.';

  @override
  String get networkError =>
      'Erreur réseau. Vérifiez votre connexion Internet.';

  @override
  String get csvDate => 'Date';

  @override
  String get csvWorkout => 'Entraînement';

  @override
  String get csvCheatDay => 'Cheat Day';

  @override
  String get csvWaterMl => 'Eau (ml)';

  @override
  String get csvTotalCalories => 'Calories totales';

  @override
  String get csvTotalProtein => 'Protéines totales (g)';

  @override
  String get csvTotalCarbs => 'Glucides totaux (g)';

  @override
  String get csvTotalFat => 'Lipides totaux (g)';

  @override
  String get csvMealCategory => 'Catégorie de repas';

  @override
  String get csvMealName => 'Nom du repas';

  @override
  String get csvYes => 'Oui';

  @override
  String get csvNo => 'Non';

  @override
  String get navFoods => 'Mes Aliments';

  @override
  String get navWorkout => 'Entraînement';

  @override
  String get foodsFavoritesTab => 'Favoris';

  @override
  String get foodsRecipesTab => 'Recettes';

  @override
  String get categoryGeneral => 'Général';

  @override
  String get categoryBreakfastDefault => 'Petit-déjeuner';

  @override
  String get categoryProteinDefault => 'Protéine';

  @override
  String get categorySnacksDefault => 'Collations';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get renameCategory => 'Renommer la catégorie';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String get deleteCategoryConfirm =>
      'Les aliments de cette catégorie seront déplacés vers Général.';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get addFood => 'Ajouter un aliment';

  @override
  String get editFood => 'Modifier l’aliment';

  @override
  String get deleteFood => 'Supprimer l’aliment';

  @override
  String get deleteFoodConfirm =>
      'Cet aliment sera retiré de votre bibliothèque.';

  @override
  String get noSavedFoods => 'Aucun aliment enregistré pour l’instant';

  @override
  String foodCount(int count) {
    return '$count aliments';
  }

  @override
  String get addRecipe => 'Ajouter une recette';

  @override
  String get editRecipe => 'Modifier la recette';

  @override
  String get deleteRecipe => 'Supprimer la recette';

  @override
  String get deleteRecipeConfirm => 'Cette recette sera supprimée.';

  @override
  String get recipeName => 'Nom de la recette';

  @override
  String get ingredients => 'Ingrédients';

  @override
  String get addIngredient => 'Ajouter un ingrédient';

  @override
  String get pickFromFoods => 'Choisir parmi mes aliments';

  @override
  String get useRecipe => 'Utiliser la recette';

  @override
  String get logRecipe => 'Ajouter au jour';

  @override
  String get recipeTotal => 'Total';

  @override
  String get noRecipes => 'Aucune recette pour l’instant';

  @override
  String ingredientCount(int count) {
    return '$count ingrédients';
  }

  @override
  String get addMealGroup => 'Ajouter un repas';

  @override
  String get editMealGroup => 'Modifier le repas';

  @override
  String get mealGroupName => 'Nom du repas';

  @override
  String mealGroupItems(int count) {
    return '$count éléments';
  }

  @override
  String get addItem => 'Ajouter un élément';

  @override
  String get quickAddFood => 'Ajouter un aliment';

  @override
  String get fromRecipe => 'À partir d’une recette';

  @override
  String get addExercise => 'Ajouter un exercice';

  @override
  String get exerciseName => 'Nom de l’exercice';

  @override
  String get deleteExercise => 'Supprimer l’exercice';

  @override
  String get deleteExerciseConfirm =>
      'Cet exercice et ses séries seront supprimés.';

  @override
  String get sets => 'Séries';

  @override
  String get reps => 'Réps';

  @override
  String get weightKg => 'Poids (kg)';

  @override
  String get addSet => 'Ajouter une série';

  @override
  String setSummary(int reps, String kg) {
    return '$reps × $kg kg';
  }

  @override
  String get noExercisesToday => 'Aucun exercice enregistré';

  @override
  String get exerciseProgress => 'Progression';

  @override
  String get maxWeightChart => 'Poids max';

  @override
  String get totalVolumeChart => 'Volume total';

  @override
  String get exerciseHistory => 'Historique';

  @override
  String get notEnoughData =>
      'Pas encore assez de données — enregistrez cet exercice sur plusieurs jours.';

  @override
  String get savedExercises => 'Exercices enregistrés';

  @override
  String get saveExerciseTooltip => 'Enregistrer l\'exercice';

  @override
  String get unsaveExerciseTooltip => 'Retirer des enregistrés';

  @override
  String get exerciseSavedSnack => 'Exercice enregistré';

  @override
  String setsCount(int count) {
    return '$count séries';
  }
}
