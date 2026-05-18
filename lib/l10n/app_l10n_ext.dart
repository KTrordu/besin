import '../models/daily_log.dart';
import '../models/meal.dart';
import 'app_localizations.dart';

extension WorkoutTypeL10n on WorkoutType {
  String l10nName(AppLocalizations l10n) {
    switch (this) {
      case WorkoutType.push:
        return l10n.workoutPush;
      case WorkoutType.pull:
        return l10n.workoutPull;
      case WorkoutType.legs:
        return l10n.workoutLegs;
      case WorkoutType.rest:
        return l10n.workoutRest;
      case WorkoutType.none:
        return l10n.workoutNone;
      case WorkoutType.light:
        return l10n.workoutLight;
      case WorkoutType.upperBody:
        return l10n.workoutUpperBody;
      case WorkoutType.lowerBody:
        return l10n.workoutLowerBody;
    }
  }
}

extension MealTypeL10n on MealType {
  String l10nName(AppLocalizations l10n) {
    switch (this) {
      case MealType.breakfast:
        return l10n.mealBreakfast;
      case MealType.lunch:
        return l10n.mealLunch;
      case MealType.dinner:
        return l10n.mealDinner;
      case MealType.snack:
        return l10n.mealSnack;
      case MealType.extra:
        return l10n.mealExtra;
    }
  }
}
