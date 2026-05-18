// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get navToday => 'Hoje';

  @override
  String get navStats => 'Estatísticas';

  @override
  String get navSettings => 'Configurações';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Salvar';

  @override
  String get saved => 'Salvo!';

  @override
  String get add => 'Adicionar';

  @override
  String get today => 'Hoje';

  @override
  String get dashTitle => 'Contador de Calorias';

  @override
  String get calories => 'Calorias';

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
  String get carbs => 'Carboidratos';

  @override
  String get fat => 'Gorduras';

  @override
  String get addMeal => 'Adicionar refeição';

  @override
  String get deleteMealTitle => 'Excluir refeição';

  @override
  String get deleteMealConfirm =>
      'Tem certeza que deseja excluir esta refeição?';

  @override
  String streakDays(int n) {
    return 'Sequência de $n dias';
  }

  @override
  String streakDaysWeekly(int n) {
    return 'Sequência de $n dias 🌟';
  }

  @override
  String streakDaysMonthly(int n) {
    return 'Sequência de $n dias 🏆';
  }

  @override
  String get streakRecord => 'Recorde';

  @override
  String get streakSubtitleGoalNotMet =>
      'Alcance seus objetivos hoje para manter sua sequência!';

  @override
  String get streakSubtitleDay1 => 'Ótimo começo! Continue amanhã!';

  @override
  String streakSubtitleToWeekly(int days) {
    return '$days dias a mais — sequência semanal!';
  }

  @override
  String streakSubtitleToMonthly(int days) {
    return 'Incrível! $days dias a mais — sequência mensal!';
  }

  @override
  String get streakSubtitleLegendary =>
      'Você tem uma sequência lendária, continue assim! 🎉';

  @override
  String get waterTitle => 'Monitoramento de água';

  @override
  String get waterGoalReached => 'Meta diária atingida! 💧';

  @override
  String waterRemaining(int n) {
    return '$n ml restantes';
  }

  @override
  String get cheatDayTitle => 'Hoje é Cheat Day!';

  @override
  String get cheatDayBannerBody =>
      'Não se preocupe com os macros hoje, aproveite! 🎉';

  @override
  String get cheatDay => 'Cheat Day';

  @override
  String get cheatDayActiveSubtitle => 'Objetivos e sequência protegidos';

  @override
  String get cheatDayInactiveSubtitle =>
      'Dê uma pausa sem quebrar sua sequência';

  @override
  String get workout => 'Treino';

  @override
  String get workoutPush => 'Push';

  @override
  String get workoutPull => 'Pull';

  @override
  String get workoutLegs => 'Pernas';

  @override
  String get workoutRest => 'Descanso';

  @override
  String get workoutNone => 'Não definido';

  @override
  String get workoutLight => 'Exercício leve';

  @override
  String get workoutUpperBody => 'Parte superior';

  @override
  String get workoutLowerBody => 'Parte inferior';

  @override
  String get mealBreakfast => 'Café da manhã';

  @override
  String get mealLunch => 'Almoço';

  @override
  String get mealDinner => 'Jantar';

  @override
  String get mealSnack => 'Lanche';

  @override
  String get mealExtra => 'Extra';

  @override
  String get editMeal => 'Editar refeição';

  @override
  String get favoriteMeals => 'Refeições favoritas';

  @override
  String get longPressRemove => '(pressão longa: remover)';

  @override
  String get barcode => 'Código de barras';

  @override
  String get barcodeSearching => 'Pesquisando no banco de dados...';

  @override
  String get barcodeScanHint => 'Escanear para preencher automaticamente';

  @override
  String get barcodeClear => 'Limpar código de barras';

  @override
  String get barcodeRescan => 'Escanear novamente';

  @override
  String get barcodeScan => 'Escanear';

  @override
  String scanRefFromFavorites(String qty) {
    return '⭐ Carregado dos favoritos: Valores baseados na porção/quantidade salva (Multiplicador: $qty).';
  }

  @override
  String get scanRefFromApi =>
      '🌐 Dados da API: Valores nutricionais baseados em 100g / 100ml. Ajuste o multiplicador.';

  @override
  String get productNotFound =>
      'Produto não encontrado no banco de dados. Insira os valores manualmente e adicione aos favoritos.';

  @override
  String get mealName => 'Nome da refeição';

  @override
  String get mealNameRequired => 'O nome da refeição não pode estar vazio';

  @override
  String get category => 'Categoria';

  @override
  String get quantityLabel => 'Quantidade / Porção';

  @override
  String quantityMultiplied(String n) {
    return 'Valores totais multiplicados por ${n}x';
  }

  @override
  String get singleServing => 'Porção única';

  @override
  String get mealTime => 'Horário da refeição';

  @override
  String get selectTime => 'Selecionar hora';

  @override
  String get nutritionValues => 'Valores nutricionais (1 porção)';

  @override
  String get caloriesKcal => 'Calorias (kcal)';

  @override
  String get proteinG => 'Proteínas (g)';

  @override
  String get carbsG => 'Carboidratos (g)';

  @override
  String get fatG => 'Gorduras (g)';

  @override
  String extraNutrientG(String name) {
    return '$name (g)';
  }

  @override
  String get invalidNumber => 'Insira um número válido';

  @override
  String get negativeNotAllowed => 'Valores negativos não são permitidos';

  @override
  String fieldRequired(String field) {
    return '$field não pode estar vazio';
  }

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get addToFavoritesSub => 'Salvar para acesso rápido';

  @override
  String get saveToFavoritesOnly => 'Salvar apenas nos favoritos / modelo';

  @override
  String get savedAsTemplate => 'Salvo nos favoritos como modelo';

  @override
  String get scanBarcode => 'Escanear código de barras';

  @override
  String get barcodeFrame => 'Alinhe o código de barras no quadro';

  @override
  String get settings => 'Configurações';

  @override
  String get dailyGoals => 'Metas diárias';

  @override
  String get calorieGoal => 'Meta calórica (kcal)';

  @override
  String get saveGoals => 'Salvar metas';

  @override
  String get cannotBeEmpty => 'Não pode estar vazio';

  @override
  String get invalidValue => 'Valor inválido';

  @override
  String get currentWeight => 'Peso atual';

  @override
  String get startWeight => 'Início';

  @override
  String get currentWeightLabel => 'Atual';

  @override
  String get weightChange => 'Variação';

  @override
  String get todayWeight => 'Peso de hoje (kg)';

  @override
  String get invalidWeightValue => 'Insira um valor de peso válido';

  @override
  String get appSettings => 'Configurações do app';

  @override
  String get showWorkoutTracking => 'Mostrar rastreamento de treino';

  @override
  String get showWorkoutTrackingSub => 'Exibe seletor de treino no painel';

  @override
  String get macrosToTrack => 'Macros a rastrear';

  @override
  String get customNutrients => 'Nutrientes personalizados';

  @override
  String get customNutrientsSub =>
      'Defina nutrientes adicionais como fibras, sódio';

  @override
  String get newNutrientHint => 'Novo nutriente (ex.: Fibras)';

  @override
  String get streakRules => 'Regras de sequência';

  @override
  String get streakRulesSub =>
      'Escolha quais metas devem ser atingidas e a margem de flexibilidade para manter sua sequência.';

  @override
  String streakFlexibility(int pct) {
    return 'Flexibilidade: $pct%';
  }

  @override
  String get calorieGoalLabel => 'Meta calórica';

  @override
  String get calorieGoalRequired => 'Meta calórica deve ser atingida';

  @override
  String get proteinGoalLabel => 'Meta de proteínas';

  @override
  String get proteinGoalRequired => 'Meta de proteínas deve ser atingida';

  @override
  String get carbsGoalLabel => 'Meta de carboidratos';

  @override
  String get carbsGoalRequired => 'Meta de carboidratos deve ser atingida';

  @override
  String get fatGoalLabel => 'Meta de gorduras';

  @override
  String get fatGoalRequired => 'Meta de gorduras deve ser atingida';

  @override
  String get dataManagement => 'Gerenciamento de dados';

  @override
  String get exportCsv => 'Exportar todos os dados (CSV)';

  @override
  String get exporting => 'Exportando...';

  @override
  String exportFailed(String error) {
    return 'Falha na exportação: $error';
  }

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String get calorieHistory => 'Histórico calórico (14 dias)';

  @override
  String get macroHistory => 'Histórico de macros (7 dias)';

  @override
  String get macroPie => 'Distribuição diária de macros';

  @override
  String get weightTracking => 'Rastreamento de peso';

  @override
  String get noWeightData =>
      'Sem dados de peso ainda.\nAdicione peso nas configurações.';

  @override
  String get weightDataInsufficient =>
      'São necessárias pelo menos 2 medições para o gráfico.';

  @override
  String get workoutCorrelation => 'Treino – Correlação de macros (30 dias)';

  @override
  String get noWorkoutData =>
      'Sem dados de treino.\nSelecione o tipo no painel.';

  @override
  String get waterStats => 'Estatísticas de água (30 dias)';

  @override
  String get generalOverview => 'Visão geral (30 dias)';

  @override
  String get noNutritionToday => 'Sem registros de nutrição para hoje.';

  @override
  String totalKcal(String kcal) {
    return 'Total: $kcal kcal';
  }

  @override
  String get dailyAvg => 'Média diária';

  @override
  String get noData => 'Sem dados';

  @override
  String get daysMetGoal => 'Dias com meta atingida';

  @override
  String get last30Days => 'Últimos 30 dias';

  @override
  String get avgDailyCalories => 'Méd. calorias diárias';

  @override
  String get avgDailyProtein => 'Méd. proteínas diárias';

  @override
  String get avgDailyCarbs => 'Méd. carboidratos diários';

  @override
  String get avgDailyFat => 'Méd. gorduras diárias';

  @override
  String avgDailyCustom(String name) {
    return 'Méd. $name diário';
  }

  @override
  String get excludingCheatDays => 'Excluindo cheat days';

  @override
  String tooltipGoal(String value) {
    return 'Meta: $value';
  }

  @override
  String workoutDays(int n) {
    return '($n dias)';
  }

  @override
  String daysCount(int n) {
    return '$n dias';
  }

  @override
  String get waterGoalThreshold => '≥ 2000 ml / dia';

  @override
  String get networkError =>
      'Erro de rede. Verifique sua conexão com a internet.';

  @override
  String get csvDate => 'Data';

  @override
  String get csvWorkout => 'Treino';

  @override
  String get csvCheatDay => 'Cheat Day';

  @override
  String get csvWaterMl => 'Água (ml)';

  @override
  String get csvTotalCalories => 'Calorias totais';

  @override
  String get csvTotalProtein => 'Proteínas totais (g)';

  @override
  String get csvTotalCarbs => 'Carboidratos totais (g)';

  @override
  String get csvTotalFat => 'Gorduras totais (g)';

  @override
  String get csvMealCategory => 'Categoria da refeição';

  @override
  String get csvMealName => 'Nome da refeição';

  @override
  String get csvYes => 'Sim';

  @override
  String get csvNo => 'Não';
}
