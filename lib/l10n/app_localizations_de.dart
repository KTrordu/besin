// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navToday => 'Heute';

  @override
  String get navStats => 'Statistiken';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get saved => 'Gespeichert!';

  @override
  String get add => 'Hinzufügen';

  @override
  String get today => 'Heute';

  @override
  String get dashTitle => 'Kalorienverfolgung';

  @override
  String get calories => 'Kalorien';

  @override
  String caloriesRemaining(String n) {
    return '$n kcal verbleibend';
  }

  @override
  String caloriesOver(String n) {
    return '$n kcal überschritten';
  }

  @override
  String get macros => 'Makros';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Kohlenhydrate';

  @override
  String get fat => 'Fett';

  @override
  String get addMeal => 'Mahlzeit hinzufügen';

  @override
  String get deleteMealTitle => 'Mahlzeit löschen';

  @override
  String get deleteMealConfirm =>
      'Möchten Sie diese Mahlzeit wirklich löschen?';

  @override
  String streakDays(int n) {
    return '$n Tage Serie';
  }

  @override
  String streakDaysWeekly(int n) {
    return '$n Tage Serie 🌟';
  }

  @override
  String streakDaysMonthly(int n) {
    return '$n Tage Serie 🏆';
  }

  @override
  String get streakRecord => 'Rekord';

  @override
  String get streakSubtitleGoalNotMet =>
      'Erreiche heute deine Ziele, um die Serie fortzusetzen!';

  @override
  String get streakSubtitleDay1 => 'Super Start! Mach morgen weiter!';

  @override
  String streakSubtitleToWeekly(int days) {
    return '$days Tage mehr — wöchentliche Serie!';
  }

  @override
  String streakSubtitleToMonthly(int days) {
    return 'Fantastisch! $days Tage mehr — monatliche Serie!';
  }

  @override
  String get streakSubtitleLegendary =>
      'Du hast eine legendäre Serie, weiter so! 🎉';

  @override
  String get waterTitle => 'Wasserverfolgung';

  @override
  String get waterGoalReached => 'Tagesziel erreicht! 💧';

  @override
  String waterRemaining(int n) {
    return '$n ml verbleibend';
  }

  @override
  String get cheatDayTitle => 'Heute ist Cheat Day!';

  @override
  String get cheatDayBannerBody =>
      'Kein Stress mit Makros heute, genieße es! 🎉';

  @override
  String get cheatDay => 'Cheat Day';

  @override
  String get cheatDayActiveSubtitle => 'Ziele und Serie sind geschützt';

  @override
  String get cheatDayInactiveSubtitle =>
      'Pause machen ohne die Serie zu brechen';

  @override
  String get workout => 'Training';

  @override
  String get workoutPush => 'Push';

  @override
  String get workoutPull => 'Pull';

  @override
  String get workoutLegs => 'Beine';

  @override
  String get workoutRest => 'Ruhetag';

  @override
  String get workoutNone => 'Nicht festgelegt';

  @override
  String get workoutLight => 'Leichtes Training';

  @override
  String get workoutUpperBody => 'Oberkörper';

  @override
  String get workoutLowerBody => 'Unterkörper';

  @override
  String get mealBreakfast => 'Frühstück';

  @override
  String get mealLunch => 'Mittagessen';

  @override
  String get mealDinner => 'Abendessen';

  @override
  String get mealSnack => 'Snack';

  @override
  String get mealExtra => 'Extra';

  @override
  String get editMeal => 'Mahlzeit bearbeiten';

  @override
  String get favoriteMeals => 'Lieblingsmahlzeiten';

  @override
  String get longPressRemove => '(lang drücken: entfernen)';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeSearching => 'Produktdatenbank wird durchsucht...';

  @override
  String get barcodeScanHint => 'Scannen zum automatischen Ausfüllen';

  @override
  String get barcodeClear => 'Barcode löschen';

  @override
  String get barcodeRescan => 'Erneut scannen';

  @override
  String get barcodeScan => 'Scannen';

  @override
  String scanRefFromFavorites(String qty) {
    return '⭐ Aus Favoriten geladen: Werte basieren auf gespeicherter Portion/Menge (Multiplikator: $qty).';
  }

  @override
  String get scanRefFromApi =>
      '🌐 API-Daten: Nährwerte basieren auf 100g / 100ml Referenz. Multiplikator entsprechend anpassen.';

  @override
  String scanRefFromServing(String size) {
    return '🌐 API-Daten: Nährwerte basieren auf 1 Portion ($size). Multiplikator entsprechend anpassen.';
  }

  @override
  String get scanRefFromServingGeneric =>
      '🌐 API-Daten: Nährwerte basieren auf 1 Portion. Multiplikator entsprechend anpassen.';

  @override
  String get productNotFound =>
      'Produkt nicht in der Datenbank gefunden. Werte manuell eingeben und zu Favoriten hinzufügen.';

  @override
  String get mealName => 'Mahlzeitname';

  @override
  String get mealNameRequired => 'Mahlzeitname darf nicht leer sein';

  @override
  String get category => 'Kategorie';

  @override
  String get quantityLabel => 'Menge / Portion';

  @override
  String quantityMultiplied(String n) {
    return 'Gesamtwerte mit ${n}x multipliziert';
  }

  @override
  String get singleServing => 'Einzelne Portion';

  @override
  String get mealTime => 'Mahlzeitzeit';

  @override
  String get selectTime => 'Zeit auswählen';

  @override
  String get nutritionValues => 'Nährwerte (1 Portion)';

  @override
  String get caloriesKcal => 'Kalorien (kcal)';

  @override
  String get proteinG => 'Protein (g)';

  @override
  String get carbsG => 'Kohlenhydrate (g)';

  @override
  String get fatG => 'Fett (g)';

  @override
  String extraNutrientG(String name) {
    return '$name (g)';
  }

  @override
  String get invalidNumber => 'Gültige Zahl eingeben';

  @override
  String get negativeNotAllowed => 'Negative Werte nicht erlaubt';

  @override
  String fieldRequired(String field) {
    return '$field darf nicht leer sein';
  }

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get addToFavoritesSub => 'Für schnellen Zugriff speichern';

  @override
  String get saveToFavoritesOnly => 'Nur in Favoriten / Vorlage speichern';

  @override
  String get savedAsTemplate => 'Als Vorlage in Favoriten gespeichert';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get barcodeFrame => 'Barcode im Rahmen ausrichten';

  @override
  String get settings => 'Einstellungen';

  @override
  String get dailyGoals => 'Tagesziele';

  @override
  String get calorieGoal => 'Kalorienziel (kcal)';

  @override
  String get saveGoals => 'Ziele speichern';

  @override
  String get cannotBeEmpty => 'Darf nicht leer sein';

  @override
  String get invalidValue => 'Ungültiger Wert';

  @override
  String get currentWeight => 'Aktuelles Gewicht';

  @override
  String get startWeight => 'Start';

  @override
  String get currentWeightLabel => 'Aktuell';

  @override
  String get weightChange => 'Änderung';

  @override
  String get todayWeight => 'Heutiges Gewicht (kg)';

  @override
  String get invalidWeightValue => 'Gültigen Gewichtswert eingeben';

  @override
  String get appSettings => 'App-Einstellungen';

  @override
  String get showWorkoutTracking => 'Trainingsverfolgung anzeigen';

  @override
  String get showWorkoutTrackingSub => 'Zeigt Trainingsauswahl im Dashboard';

  @override
  String get macrosToTrack => 'Zu verfolgende Makros';

  @override
  String get customNutrients => 'Benutzerdefinierte Nährstoffe';

  @override
  String get customNutrientsSub =>
      'Zusätzliche Nährstoffe wie Ballaststoffe, Natrium definieren';

  @override
  String get newNutrientHint => 'Neuer Nährstoff (z.B.: Ballaststoffe)';

  @override
  String get streakRules => 'Serie-Regeln';

  @override
  String get streakRulesSub =>
      'Wählen Sie, welche Ziele erreicht werden müssen, um Ihre tägliche Serie aufrechtzuerhalten.';

  @override
  String streakFlexibility(int pct) {
    return 'Zielflexibilität: $pct%';
  }

  @override
  String get calorieGoalLabel => 'Kalorienziel';

  @override
  String get calorieGoalRequired => 'Kalorienziel muss erreicht werden';

  @override
  String get proteinGoalLabel => 'Proteinziel';

  @override
  String get proteinGoalRequired => 'Proteinziel muss erreicht werden';

  @override
  String get carbsGoalLabel => 'Kohlenhydratziel';

  @override
  String get carbsGoalRequired => 'Kohlenhydratziel muss erreicht werden';

  @override
  String get fatGoalLabel => 'Fettziel';

  @override
  String get fatGoalRequired => 'Fettziel muss erreicht werden';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get exportCsv => 'Alle Daten exportieren (CSV)';

  @override
  String get exporting => 'Wird exportiert...';

  @override
  String exportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get statsTitle => 'Statistiken';

  @override
  String get calorieHistory => 'Kalorienhistorie (14 Tage)';

  @override
  String get macroHistory => 'Makrohistorie (7 Tage)';

  @override
  String get macroPie => 'Tägliche Makroverteilung';

  @override
  String get weightTracking => 'Gewichtsverfolgung';

  @override
  String get noWeightData =>
      'Noch keine Gewichtsdaten.\nGewicht in den Einstellungen hinzufügen.';

  @override
  String get weightDataInsufficient =>
      'Mindestens 2 Messungen für das Diagramm erforderlich.';

  @override
  String get workoutCorrelation => 'Training – Makro-Korrelation (30 Tage)';

  @override
  String get noWorkoutData =>
      'Keine Trainingsdaten.\nTrainingstyp im Dashboard auswählen.';

  @override
  String get waterStats => 'Wasserstatistiken (30 Tage)';

  @override
  String get generalOverview => 'Allgemeiner Überblick (30 Tage)';

  @override
  String get noNutritionToday => 'Heute noch keine Ernährung erfasst.';

  @override
  String totalKcal(String kcal) {
    return 'Gesamt: $kcal kcal';
  }

  @override
  String get dailyAvg => 'Tagesdurchschnitt';

  @override
  String get noData => 'Keine Daten';

  @override
  String get daysMetGoal => 'Tage mit erreichtem Ziel';

  @override
  String get last30Days => 'Letzte 30 Tage';

  @override
  String get avgDailyCalories => 'Ø Tägliche Kalorien';

  @override
  String get avgDailyProtein => 'Ø Tägliches Protein';

  @override
  String get avgDailyCarbs => 'Ø Tägliche Kohlenhydrate';

  @override
  String get avgDailyFat => 'Ø Tägliches Fett';

  @override
  String avgDailyCustom(String name) {
    return 'Ø Tägliches $name';
  }

  @override
  String get excludingCheatDays => 'Cheat Days ausgeschlossen';

  @override
  String tooltipGoal(String value) {
    return 'Ziel: $value';
  }

  @override
  String workoutDays(int n) {
    return '($n Tage)';
  }

  @override
  String daysCount(int n) {
    return '$n Tage';
  }

  @override
  String get waterGoalThreshold => '≥ 2000 ml / Tag';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get backupJson => 'Sichern (JSON)';

  @override
  String get backupJsonSub => 'Alle Daten als JSON-Sicherungsdatei exportieren';

  @override
  String get restoreJson => 'Wiederherstellen (JSON)';

  @override
  String get restoreJsonSub => 'Daten aus JSON-Sicherungsdatei importieren';

  @override
  String get backingUp => 'Wird gesichert...';

  @override
  String get restoring => 'Wird wiederhergestellt...';

  @override
  String get backupSuccess =>
      'Sicherung bereit — Speicher- oder Freigabeort wählen';

  @override
  String get restoreSuccess => 'Daten erfolgreich wiederhergestellt';

  @override
  String get restoreInvalidFormat =>
      'Ungültige Sicherungsdatei. Bitte eine gültige Besin-Sicherung auswählen.';

  @override
  String get restorePickCancelled => 'Keine Datei ausgewählt';

  @override
  String backupFailed(String error) {
    return 'Sicherung fehlgeschlagen: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Wiederherstellung fehlgeschlagen: $error';
  }

  @override
  String get restoreConfirmTitle => 'Sicherung wiederherstellen?';

  @override
  String get restoreConfirmBody =>
      'Dadurch werden alle aktuellen Daten überschrieben. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get networkError => 'Netzwerkfehler. Bitte Internetverbindung prüfen.';

  @override
  String get csvDate => 'Datum';

  @override
  String get csvWorkout => 'Training';

  @override
  String get csvCheatDay => 'Cheat Day';

  @override
  String get csvWaterMl => 'Wasser (ml)';

  @override
  String get csvTotalCalories => 'Gesamtkalorien';

  @override
  String get csvTotalProtein => 'Gesamtprotein (g)';

  @override
  String get csvTotalCarbs => 'Gesamtkohlenhydrate (g)';

  @override
  String get csvTotalFat => 'Gesamtfett (g)';

  @override
  String get csvMealCategory => 'Mahlzeitkategorie';

  @override
  String get csvMealName => 'Mahlzeitname';

  @override
  String get csvYes => 'Ja';

  @override
  String get csvNo => 'Nein';

  @override
  String get flexibleMacroDay => 'Flexibler Makro-Tag';

  @override
  String get flexibleMacroDayInactiveSub =>
      'Verfolge nur ein Makro, ignoriere den Rest';

  @override
  String flexibleMacroDayActiveSub(String macro) {
    return 'Heute zählt nur $macro';
  }
}
