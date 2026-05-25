// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navToday => 'Hoy';

  @override
  String get navStats => 'Estadísticas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get saved => '¡Guardado!';

  @override
  String get add => 'Añadir';

  @override
  String get today => 'Hoy';

  @override
  String get dashTitle => 'Contador de Calorías';

  @override
  String get calories => 'Calorías';

  @override
  String caloriesRemaining(String n) {
    return '$n kcal restantes';
  }

  @override
  String caloriesOver(String n) {
    return '$n kcal excedidas';
  }

  @override
  String get macros => 'Macros';

  @override
  String get protein => 'Proteínas';

  @override
  String get carbs => 'Carbohidratos';

  @override
  String get fat => 'Grasas';

  @override
  String get addMeal => 'Añadir comida';

  @override
  String get deleteMealTitle => 'Eliminar comida';

  @override
  String get deleteMealConfirm =>
      '¿Está seguro de que desea eliminar esta comida?';

  @override
  String streakDays(int n) {
    return 'Racha de $n días';
  }

  @override
  String streakDaysWeekly(int n) {
    return 'Racha de $n días 🌟';
  }

  @override
  String streakDaysMonthly(int n) {
    return 'Racha de $n días 🏆';
  }

  @override
  String get streakRecord => 'Récord';

  @override
  String get streakSubtitleGoalNotMet =>
      '¡Alcanza tus objetivos hoy para mantener tu racha!';

  @override
  String get streakSubtitleDay1 => '¡Gran inicio! ¡Sigue mañana!';

  @override
  String streakSubtitleToWeekly(int days) {
    return '$days días más — ¡racha semanal!';
  }

  @override
  String streakSubtitleToMonthly(int days) {
    return '¡Increíble! $days días más — ¡racha mensual!';
  }

  @override
  String get streakSubtitleLegendary =>
      '¡Tienes una racha legendaria, sigue así! 🎉';

  @override
  String get waterTitle => 'Seguimiento de agua';

  @override
  String get waterGoalReached => '¡Objetivo diario alcanzado! 💧';

  @override
  String waterRemaining(int n) {
    return '$n ml restantes';
  }

  @override
  String get cheatDayTitle => '¡Hoy es Cheat Day!';

  @override
  String get cheatDayBannerBody =>
      '¡No te preocupes por los macros hoy, disfruta! 🎉';

  @override
  String get cheatDay => 'Cheat Day';

  @override
  String get cheatDayActiveSubtitle => 'Objetivos y racha protegidos';

  @override
  String get cheatDayInactiveSubtitle =>
      'Tómate un descanso sin romper tu racha';

  @override
  String get workout => 'Entrenamiento';

  @override
  String get workoutPush => 'Push';

  @override
  String get workoutPull => 'Pull';

  @override
  String get workoutLegs => 'Piernas';

  @override
  String get workoutRest => 'Descanso';

  @override
  String get workoutNone => 'No especificado';

  @override
  String get workoutLight => 'Ejercicio ligero';

  @override
  String get workoutUpperBody => 'Tren superior';

  @override
  String get workoutLowerBody => 'Tren inferior';

  @override
  String get mealBreakfast => 'Desayuno';

  @override
  String get mealLunch => 'Almuerzo';

  @override
  String get mealDinner => 'Cena';

  @override
  String get mealSnack => 'Merienda';

  @override
  String get mealExtra => 'Extra';

  @override
  String get editMeal => 'Editar comida';

  @override
  String get favoriteMeals => 'Comidas favoritas';

  @override
  String get longPressRemove => '(pulsación larga: eliminar)';

  @override
  String get barcode => 'Código de barras';

  @override
  String get barcodeSearching => 'Buscando en la base de datos...';

  @override
  String get barcodeScanHint => 'Escanear para rellenar automáticamente';

  @override
  String get barcodeClear => 'Borrar código de barras';

  @override
  String get barcodeRescan => 'Reescanear';

  @override
  String get barcodeScan => 'Escanear';

  @override
  String scanRefFromFavorites(String qty) {
    return '⭐ Cargado desde favoritos: Valores basados en la porción/cantidad guardada (Multiplicador: $qty).';
  }

  @override
  String get scanRefFromApi =>
      '🌐 Datos de API: Valores nutricionales basados en 100g / 100ml. Ajuste el multiplicador.';

  @override
  String scanRefFromServing(String size) {
    return '🌐 Datos de API: Valores nutricionales basados en 1 porción ($size). Ajuste el multiplicador.';
  }

  @override
  String get scanRefFromServingGeneric =>
      '🌐 Datos de API: Valores nutricionales basados en 1 porción. Ajuste el multiplicador.';

  @override
  String get productNotFound =>
      'Producto no encontrado. Introduzca los valores manualmente y añada a favoritos.';

  @override
  String get mealName => 'Nombre de la comida';

  @override
  String get mealNameRequired => 'El nombre de la comida no puede estar vacío';

  @override
  String get category => 'Categoría';

  @override
  String get quantityLabel => 'Cantidad / Porción';

  @override
  String quantityMultiplied(String n) {
    return 'Valores totales multiplicados por ${n}x';
  }

  @override
  String get singleServing => 'Porción única';

  @override
  String get mealTime => 'Hora de la comida';

  @override
  String get selectTime => 'Seleccionar hora';

  @override
  String get nutritionValues => 'Valores nutricionales (1 porción)';

  @override
  String get caloriesKcal => 'Calorías (kcal)';

  @override
  String get proteinG => 'Proteínas (g)';

  @override
  String get carbsG => 'Carbohidratos (g)';

  @override
  String get fatG => 'Grasas (g)';

  @override
  String extraNutrientG(String name) {
    return '$name (g)';
  }

  @override
  String get invalidNumber => 'Introduce un número válido';

  @override
  String get negativeNotAllowed => 'No se permiten valores negativos';

  @override
  String fieldRequired(String field) {
    return '$field no puede estar vacío';
  }

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get addToFavoritesSub => 'Guardar para acceso rápido';

  @override
  String get saveToFavoritesOnly => 'Guardar solo en favoritos / plantilla';

  @override
  String get savedAsTemplate => 'Guardado en favoritos como plantilla';

  @override
  String get scanBarcode => 'Escanear código de barras';

  @override
  String get barcodeFrame => 'Alinee el código de barras en el marco';

  @override
  String get settings => 'Ajustes';

  @override
  String get dailyGoals => 'Objetivos diarios';

  @override
  String get calorieGoal => 'Objetivo calórico (kcal)';

  @override
  String get saveGoals => 'Guardar objetivos';

  @override
  String get cannotBeEmpty => 'No puede estar vacío';

  @override
  String get invalidValue => 'Valor inválido';

  @override
  String get currentWeight => 'Peso actual';

  @override
  String get startWeight => 'Inicio';

  @override
  String get currentWeightLabel => 'Actual';

  @override
  String get weightChange => 'Cambio';

  @override
  String get todayWeight => 'Peso de hoy (kg)';

  @override
  String get invalidWeightValue => 'Introduce un valor de peso válido';

  @override
  String get appSettings => 'Configuración de la app';

  @override
  String get showWorkoutTracking => 'Mostrar seguimiento de entrenamiento';

  @override
  String get showWorkoutTrackingSub =>
      'Muestra el selector de entrenamiento en el panel';

  @override
  String get macrosToTrack => 'Macros a seguir';

  @override
  String get customNutrients => 'Nutrientes personalizados';

  @override
  String get customNutrientsSub =>
      'Define nutrientes adicionales como fibra, sodio';

  @override
  String get newNutrientHint => 'Nuevo nutriente (ej.: Fibra)';

  @override
  String get streakRules => 'Reglas de racha';

  @override
  String get streakRulesSub =>
      'Elige qué objetivos deben cumplirse y el margen de flexibilidad para mantener tu racha.';

  @override
  String streakFlexibility(int pct) {
    return 'Flexibilidad: $pct%';
  }

  @override
  String get calorieGoalLabel => 'Objetivo calórico';

  @override
  String get calorieGoalRequired => 'El objetivo calórico debe alcanzarse';

  @override
  String get proteinGoalLabel => 'Objetivo de proteínas';

  @override
  String get proteinGoalRequired => 'El objetivo de proteínas debe alcanzarse';

  @override
  String get carbsGoalLabel => 'Objetivo de carbohidratos';

  @override
  String get carbsGoalRequired =>
      'El objetivo de carbohidratos debe alcanzarse';

  @override
  String get fatGoalLabel => 'Objetivo de grasas';

  @override
  String get fatGoalRequired => 'El objetivo de grasas debe alcanzarse';

  @override
  String get dataManagement => 'Gestión de datos';

  @override
  String get exportCsv => 'Exportar todos los datos (CSV)';

  @override
  String get exporting => 'Exportando...';

  @override
  String exportFailed(String error) {
    return 'Error en la exportación: $error';
  }

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get calorieHistory => 'Historial calórico (14 días)';

  @override
  String get macroHistory => 'Historial de macros (7 días)';

  @override
  String get macroPie => 'Distribución diaria de macros';

  @override
  String get weightTracking => 'Seguimiento de peso';

  @override
  String get noWeightData =>
      'Sin datos de peso aún.\nAñade peso en los ajustes.';

  @override
  String get weightDataInsufficient =>
      'Se necesitan al menos 2 mediciones para el gráfico.';

  @override
  String get workoutCorrelation =>
      'Entrenamiento – Correlación de macros (30 días)';

  @override
  String get noWorkoutData =>
      'Sin datos de entrenamiento.\nSelecciona tipo desde el panel.';

  @override
  String get waterStats => 'Estadísticas de agua (30 días)';

  @override
  String get generalOverview => 'Resumen general (30 días)';

  @override
  String get noNutritionToday => 'Sin registros de nutrición para hoy.';

  @override
  String totalKcal(String kcal) {
    return 'Total: $kcal kcal';
  }

  @override
  String get dailyAvg => 'Promedio diario';

  @override
  String get noData => 'Sin datos';

  @override
  String get daysMetGoal => 'Días con objetivo cumplido';

  @override
  String get last30Days => 'Últimos 30 días';

  @override
  String get avgDailyCalories => 'Prom. calorías diarias';

  @override
  String get avgDailyProtein => 'Prom. proteínas diarias';

  @override
  String get avgDailyCarbs => 'Prom. carbohidratos diarios';

  @override
  String get avgDailyFat => 'Prom. grasas diarias';

  @override
  String avgDailyCustom(String name) {
    return 'Prom. $name diario';
  }

  @override
  String get excludingCheatDays => 'Excluyendo cheat days';

  @override
  String tooltipGoal(String value) {
    return 'Objetivo: $value';
  }

  @override
  String workoutDays(int n) {
    return '($n días)';
  }

  @override
  String daysCount(int n) {
    return '$n días';
  }

  @override
  String get waterGoalThreshold => '≥ 2000 ml / día';

  @override
  String get confirm => 'Confirmar';

  @override
  String get backupJson => 'Copia de seguridad (JSON)';

  @override
  String get backupJsonSub =>
      'Exportar todos los datos como archivo JSON de copia de seguridad';

  @override
  String get restoreJson => 'Restaurar (JSON)';

  @override
  String get restoreJsonSub =>
      'Importar datos desde un archivo JSON de copia de seguridad';

  @override
  String get backingUp => 'Creando copia de seguridad...';

  @override
  String get restoring => 'Restaurando...';

  @override
  String get backupSuccess => 'Copia lista — elige dónde guardar o compartir';

  @override
  String get restoreSuccess => 'Datos restaurados correctamente';

  @override
  String get restoreInvalidFormat =>
      'Archivo de copia inválido. Selecciona una copia de seguridad de Besin válida.';

  @override
  String get restorePickCancelled => 'Ningún archivo seleccionado';

  @override
  String backupFailed(String error) {
    return 'Error en la copia de seguridad: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Error al restaurar: $error';
  }

  @override
  String get restoreConfirmTitle => '¿Restaurar copia de seguridad?';

  @override
  String get restoreConfirmBody =>
      'Esto sobreescribirá todos los datos actuales. Esta acción no se puede deshacer.';

  @override
  String get networkError => 'Error de red. Comprueba tu conexión a Internet.';

  @override
  String get csvDate => 'Fecha';

  @override
  String get csvWorkout => 'Entrenamiento';

  @override
  String get csvCheatDay => 'Cheat Day';

  @override
  String get csvWaterMl => 'Agua (ml)';

  @override
  String get csvTotalCalories => 'Calorías totales';

  @override
  String get csvTotalProtein => 'Proteínas totales (g)';

  @override
  String get csvTotalCarbs => 'Carbohidratos totales (g)';

  @override
  String get csvTotalFat => 'Grasas totales (g)';

  @override
  String get csvMealCategory => 'Categoría de comida';

  @override
  String get csvMealName => 'Nombre de la comida';

  @override
  String get csvYes => 'Sí';

  @override
  String get csvNo => 'No';

  @override
  String get flexibleMacroDay => 'Día de Macro Flexible';

  @override
  String get flexibleMacroDayInactiveSub =>
      'Sigue solo un macro, olvida el resto';

  @override
  String flexibleMacroDayActiveSub(String macro) {
    return 'Solo $macro importa hoy';
  }
}
