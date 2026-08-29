// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get navToday => 'Bugün';

  @override
  String get navStats => 'İstatistikler';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get saved => 'Kaydedildi!';

  @override
  String get add => 'Ekle';

  @override
  String get today => 'Bugün';

  @override
  String get dashTitle => 'Kalori Takip';

  @override
  String get calories => 'Kalori';

  @override
  String caloriesRemaining(String n) {
    return '$n kcal kaldı';
  }

  @override
  String caloriesOver(String n) {
    return '$n kcal aşıldı';
  }

  @override
  String get macros => 'Makrolar';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Karbonhidrat';

  @override
  String get fat => 'Yağ';

  @override
  String get addMeal => 'Öğün Ekle';

  @override
  String get deleteMealTitle => 'Öğünü Sil';

  @override
  String get deleteMealConfirm =>
      'Bu öğünü silmek istediğinizden emin misiniz?';

  @override
  String streakDays(int n) {
    return '$n Günlük Seri';
  }

  @override
  String streakDaysWeekly(int n) {
    return '$n Günlük Seri 🌟';
  }

  @override
  String streakDaysMonthly(int n) {
    return '$n Günlük Seri 🏆';
  }

  @override
  String get streakRecord => 'Rekor';

  @override
  String get streakSubtitleGoalNotMet =>
      'Seriyi sürdürmek için bugün hedeflere ulaş!';

  @override
  String get streakSubtitleDay1 => 'Harika başlangıç! Yarın da devam et!';

  @override
  String streakSubtitleToWeekly(int days) {
    return '$days gün daha — haftalık seriye ulaş!';
  }

  @override
  String streakSubtitleToMonthly(int days) {
    return 'Müthiş! $days gün daha — aylık seriye!';
  }

  @override
  String get streakSubtitleLegendary =>
      'Efsanevi bir serin var, öyle devam et! 🎉';

  @override
  String get waterTitle => 'Su Takibi';

  @override
  String get waterGoalReached => 'Günlük hedefe ulaştın! 💧';

  @override
  String waterRemaining(int n) {
    return '$n ml kaldı';
  }

  @override
  String get cheatDayTitle => 'Bugün Cheat Day!';

  @override
  String get cheatDayBannerBody =>
      'Bugün makroları dert etme, afiyet olsun! 🎉';

  @override
  String get cheatDay => 'Cheat Day';

  @override
  String get cheatDayActiveSubtitle => 'Hedefler ve seri korunuyor';

  @override
  String get cheatDayInactiveSubtitle => 'Seriyi bozmadan kaçamak yap';

  @override
  String get workout => 'Antrenman';

  @override
  String get workoutPush => 'Push';

  @override
  String get workoutPull => 'Pull';

  @override
  String get workoutLegs => 'Legs';

  @override
  String get workoutRest => 'Dinlenme';

  @override
  String get workoutFullBody => 'Full Body';

  @override
  String get workoutNone => 'Belirtilmedi';

  @override
  String get workoutLight => 'Hafif Egzersiz';

  @override
  String get workoutUpperBody => 'Upper Body';

  @override
  String get workoutLowerBody => 'Lower Body';

  @override
  String get mealBreakfast => 'Kahvaltı';

  @override
  String get mealLunch => 'Öğle';

  @override
  String get mealDinner => 'Akşam';

  @override
  String get mealSnack => 'Ara Öğün';

  @override
  String get mealExtra => 'Atıştırmalık';

  @override
  String get editMeal => 'Öğünü Düzenle';

  @override
  String get favoriteMeals => 'Favori Öğünler';

  @override
  String get longPressRemove => '(uzun bas: kaldır)';

  @override
  String get barcode => 'Barkod';

  @override
  String get barcodeSearching => 'Ürün veritabanında aranıyor...';

  @override
  String get barcodeScanHint => 'Otomatik doldurmak için tara';

  @override
  String get barcodeClear => 'Barkodu temizle';

  @override
  String get barcodeRescan => 'Yeniden';

  @override
  String get barcodeScan => 'Tara';

  @override
  String scanRefFromFavorites(String qty) {
    return '⭐ Favorilerden Yüklendi: Bu değerler favoriye eklediğiniz porsiyon/adet (Çarpan: $qty) baz alınarak doldurulmuştur.';
  }

  @override
  String get scanRefFromApi =>
      '🌐 API Verisi: Bu besin değerleri 100g / 100ml referans alınarak doldurulmuştur. Çarpanı buna göre ayarlayın.';

  @override
  String scanRefFromServing(String size) {
    return '🌐 API Verisi: Bu besin değerleri 1 porsiyon ($size) referans alınarak doldurulmuştur. Çarpanı buna göre ayarlayın.';
  }

  @override
  String get scanRefFromServingGeneric =>
      '🌐 API Verisi: Bu besin değerleri 1 porsiyon referans alınarak doldurulmuştur. Çarpanı buna göre ayarlayın.';

  @override
  String get productNotFound =>
      'Ürün veritabanında bulunamadı, lütfen değerleri manuel girerek favorilerinize ekleyin.';

  @override
  String get mealName => 'Öğün Adı';

  @override
  String get mealNameRequired => 'Öğün adı boş bırakılamaz';

  @override
  String get category => 'Kategori';

  @override
  String get quantityLabel => 'Adet / Porsiyon';

  @override
  String quantityMultiplied(String n) {
    return 'Toplam değerler ${n}x çarpılır';
  }

  @override
  String get singleServing => 'Tek porsiyon';

  @override
  String get mealTime => 'Öğün Saati';

  @override
  String get selectTime => 'Saat Seç';

  @override
  String get nutritionValues => 'Besin Değerleri (1 porsiyon)';

  @override
  String get caloriesKcal => 'Kalori (kcal)';

  @override
  String get proteinG => 'Protein (g)';

  @override
  String get carbsG => 'Karbonhidrat (g)';

  @override
  String get fatG => 'Yağ (g)';

  @override
  String extraNutrientG(String name) {
    return '$name (g)';
  }

  @override
  String get invalidNumber => 'Geçerli bir sayı girin';

  @override
  String get negativeNotAllowed => 'Negatif değer girilemez';

  @override
  String fieldRequired(String field) {
    return '$field boş bırakılamaz';
  }

  @override
  String get addToFavorites => 'Favorilere Ekle';

  @override
  String get addToFavoritesSub => 'Hızlı erişim için kaydet';

  @override
  String get saveToFavoritesOnly => 'Sadece Favorilere / Şablona Kaydet';

  @override
  String get savedAsTemplate => 'Şablon olarak favorilere eklendi';

  @override
  String get scanBarcode => 'Barkod Tara';

  @override
  String get barcodeFrame => 'Barkodu çerçeveye getirin';

  @override
  String get settings => 'Ayarlar';

  @override
  String get dailyGoals => 'Günlük Hedefler';

  @override
  String get calorieGoal => 'Kalori Hedefi (kcal)';

  @override
  String get saveGoals => 'Hedefleri Kaydet';

  @override
  String get cannotBeEmpty => 'Boş bırakılamaz';

  @override
  String get invalidValue => 'Geçersiz değer';

  @override
  String get currentWeight => 'Mevcut Kilo';

  @override
  String get startWeight => 'Başlangıç';

  @override
  String get currentWeightLabel => 'Güncel';

  @override
  String get weightChange => 'Değişim';

  @override
  String get todayWeight => 'Bugünkü Kilo (kg)';

  @override
  String get invalidWeightValue => 'Geçerli bir kilo değeri girin';

  @override
  String get appSettings => 'Uygulama Ayarları';

  @override
  String get showWorkoutTracking => 'Antrenman Takibini Göster';

  @override
  String get showWorkoutTrackingSub =>
      'Dashboard\'da antrenman seçiciyi gösterir';

  @override
  String get macrosToTrack => 'Takip Edilecek Makrolar';

  @override
  String get customNutrients => 'Özel Besinler';

  @override
  String get customNutrientsSub =>
      'Lif, Sodyum gibi ek besin değerleri tanımlayın';

  @override
  String get newNutrientHint => 'Yeni besin adı (ör: Lif)';

  @override
  String get streakRules => 'Seri (Streak) Kuralları';

  @override
  String get streakRulesSub =>
      'Günlük seriyi sürdürmek için hangi hedeflerin karşılanması gerektiğini ve esneklik payını seçin.';

  @override
  String streakFlexibility(int pct) {
    return 'Hedef Esnekliği: %$pct';
  }

  @override
  String get calorieGoalLabel => 'Kalori Hedefi';

  @override
  String get calorieGoalRequired => 'Kalori hedefi zorunlu tutulsun';

  @override
  String get proteinGoalLabel => 'Protein Hedefi';

  @override
  String get proteinGoalRequired => 'Protein hedefi zorunlu tutulsun';

  @override
  String get carbsGoalLabel => 'Karbonhidrat Hedefi';

  @override
  String get carbsGoalRequired => 'Karb hedefi zorunlu tutulsun';

  @override
  String get fatGoalLabel => 'Yağ Hedefi';

  @override
  String get fatGoalRequired => 'Yağ hedefi zorunlu tutulsun';

  @override
  String get dataManagement => 'Veri Yönetimi';

  @override
  String get exportCsv => 'Tüm Verileri Dışa Aktar (CSV)';

  @override
  String get exporting => 'Dışa Aktarılıyor...';

  @override
  String exportFailed(String error) {
    return 'Dışa aktarma başarısız: $error';
  }

  @override
  String get statsTitle => 'İstatistikler';

  @override
  String get calorieHistory => 'Kalori Geçmişi (14 Gün)';

  @override
  String get macroHistory => 'Makro Geçmişi (7 Gün)';

  @override
  String get macroPie => 'Günlük Makro Dağılımı';

  @override
  String get weightTracking => 'Kilo Takibi';

  @override
  String get noWeightData =>
      'Henüz kilo verisi yok.\nAyarlar ekranından kilo ekleyebilirsiniz.';

  @override
  String get weightDataInsufficient => 'Grafik için en az 2 ölçüm gereklidir.';

  @override
  String get workoutCorrelation => 'Antrenman – Makro Korelasyonu (30 Gün)';

  @override
  String get noWorkoutData =>
      'Antrenman verisi yok.\nDashboard\'dan antrenman tipi seçin.';

  @override
  String get waterStats => 'Su İstatistikleri (30 Gün)';

  @override
  String get generalOverview => 'Genel Özet (30 Gün)';

  @override
  String get noNutritionToday => 'Bu gün için henüz besin kaydı yok.';

  @override
  String totalKcal(String kcal) {
    return 'Toplam: $kcal kcal';
  }

  @override
  String get dailyAvg => 'Günlük Ortalama';

  @override
  String get noData => 'Veri yok';

  @override
  String get daysMetGoal => 'Hedefe Ulaşılan Gün';

  @override
  String get last30Days => 'Son 30 gün';

  @override
  String get last90Days => 'Son 90 gün';

  @override
  String get allTime => 'Tümü';

  @override
  String get avgDailyCalories => 'Ort. Günlük Kalori';

  @override
  String get avgDailyProtein => 'Ort. Günlük Protein';

  @override
  String get avgDailyCarbs => 'Ort. Günlük Karbonhidrat';

  @override
  String get avgDailyFat => 'Ort. Günlük Yağ';

  @override
  String avgDailyCustom(String name) {
    return 'Ort. Günlük $name';
  }

  @override
  String get excludingCheatDays => 'Cheat day hariç';

  @override
  String tooltipGoal(String value) {
    return 'Hedef: $value';
  }

  @override
  String workoutDays(int n) {
    return '($n gün)';
  }

  @override
  String daysCount(int n) {
    return '$n gün';
  }

  @override
  String get waterGoalThreshold => '≥ 2000 ml / gün';

  @override
  String get confirm => 'Onayla';

  @override
  String get backupJson => 'Yedekle (JSON)';

  @override
  String get backupJsonSub =>
      'Tüm verileri JSON yedek dosyası olarak dışa aktar';

  @override
  String get restoreJson => 'Geri Yükle (JSON)';

  @override
  String get restoreJsonSub => 'JSON yedek dosyasından verileri içe aktar';

  @override
  String get backingUp => 'Yedekleniyor...';

  @override
  String get restoring => 'Geri yükleniyor...';

  @override
  String get backupSuccess =>
      'Yedek hazır — kaydetmek veya paylaşmak için yer seçin';

  @override
  String get restoreSuccess => 'Veriler başarıyla geri yüklendi';

  @override
  String get restoreInvalidFormat =>
      'Geçersiz yedek dosyası. Lütfen geçerli bir Besin yedeği seçin.';

  @override
  String get restorePickCancelled => 'Dosya seçilmedi';

  @override
  String backupFailed(String error) {
    return 'Yedekleme başarısız: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Geri yükleme başarısız: $error';
  }

  @override
  String get restoreConfirmTitle => 'Yedek Geri Yüklensin mi?';

  @override
  String get restoreConfirmBody =>
      'Bu işlem mevcut tüm verilerin üzerine yazacak. Bu işlem geri alınamaz.';

  @override
  String get networkError => 'Ağ hatası. İnternet bağlantınızı kontrol edin.';

  @override
  String get csvDate => 'Tarih';

  @override
  String get csvWorkout => 'Antrenman';

  @override
  String get csvCheatDay => 'Cheat Day';

  @override
  String get csvWaterMl => 'Su (ml)';

  @override
  String get csvTotalCalories => 'Toplam Kalori';

  @override
  String get csvTotalProtein => 'Toplam Protein (g)';

  @override
  String get csvTotalCarbs => 'Toplam Karb (g)';

  @override
  String get csvTotalFat => 'Toplam Yağ (g)';

  @override
  String get csvMealCategory => 'Öğün Kategorisi';

  @override
  String get csvMealName => 'Öğün Adı';

  @override
  String get csvYes => 'Evet';

  @override
  String get csvNo => 'Hayır';

  @override
  String get navFoods => 'Besinlerim';

  @override
  String get navWorkout => 'Antrenman';

  @override
  String get foodsFavoritesTab => 'Favoriler';

  @override
  String get foodsRecipesTab => 'Tarifler';

  @override
  String get categoryGeneral => 'Genel';

  @override
  String get categoryBreakfastDefault => 'Kahvaltılık';

  @override
  String get categoryProteinDefault => 'Protein';

  @override
  String get categorySnacksDefault => 'Atıştırmalık';

  @override
  String get addCategory => 'Kategori ekle';

  @override
  String get categoryOrder => 'Kategori sırası';

  @override
  String get manualOrder => 'Elle sıralama';

  @override
  String get alphabeticalOrder => 'Alfabetik';

  @override
  String get newestOrder => 'En yeni';

  @override
  String get oldestOrder => 'En eski';

  @override
  String get createSortPreset => 'Özel sıralama oluştur';

  @override
  String get sortPresetName => 'Sıralama adı';

  @override
  String get reorderCategories => 'Kategorileri sırala';

  @override
  String get noFoodsInCategory => 'Bu kategoride kayıtlı besin yok';

  @override
  String get renameCategory => 'Kategoriyi yeniden adlandır';

  @override
  String get deleteCategory => 'Kategoriyi sil';

  @override
  String get deleteCategoryConfirm =>
      'Bu kategorideki besinler Genel’e taşınacak.';

  @override
  String get categoryName => 'Kategori adı';

  @override
  String get addFood => 'Besin ekle';

  @override
  String get editFood => 'Besini düzenle';

  @override
  String get deleteFood => 'Besini sil';

  @override
  String get deleteFoodConfirm => 'Bu besin kütüphanenizden kaldırılacak.';

  @override
  String get noSavedFoods => 'Henüz kayıtlı besin yok';

  @override
  String foodCount(int count) {
    return '$count besin';
  }

  @override
  String get addRecipe => 'Tarif ekle';

  @override
  String get editRecipe => 'Tarifi düzenle';

  @override
  String get deleteRecipe => 'Tarifi sil';

  @override
  String get deleteRecipeConfirm => 'Bu tarif silinecek.';

  @override
  String get recipeName => 'Tarif adı';

  @override
  String get ingredients => 'Malzemeler';

  @override
  String get addIngredient => 'Malzeme ekle';

  @override
  String get pickFromFoods => 'Besinlerimden seç';

  @override
  String get useRecipe => 'Tarifi kullan';

  @override
  String get logRecipe => 'Güne ekle';

  @override
  String get recipeTotal => 'Toplam';

  @override
  String get noRecipes => 'Henüz tarif yok';

  @override
  String ingredientCount(int count) {
    return '$count malzeme';
  }

  @override
  String get addMealGroup => 'Öğün ekle';

  @override
  String get editMealGroup => 'Öğünü düzenle';

  @override
  String get mealGroupName => 'Öğün adı';

  @override
  String mealGroupItems(int count) {
    return '$count kalem';
  }

  @override
  String get addItem => 'Kalem ekle';

  @override
  String get quickAddFood => 'Besin ekle';

  @override
  String get fromRecipe => 'Tariften';

  @override
  String get addExercise => 'Egzersiz ekle';

  @override
  String get exerciseName => 'Egzersiz adı';

  @override
  String get deleteExercise => 'Egzersizi sil';

  @override
  String get deleteExerciseConfirm => 'Bu egzersiz ve setleri silinecek.';

  @override
  String get sets => 'Set';

  @override
  String get reps => 'Tekrar';

  @override
  String get weightKg => 'Ağırlık (kg)';

  @override
  String get addSet => 'Set ekle';

  @override
  String setSummary(int reps, String kg) {
    return '$reps × $kg kg';
  }

  @override
  String get noExercisesToday => 'Kayıtlı egzersiz yok';

  @override
  String get exerciseProgress => 'Gelişim';

  @override
  String get maxWeightChart => 'Maks. ağırlık';

  @override
  String get totalVolumeChart => 'Toplam hacim';

  @override
  String get exerciseHistory => 'Geçmiş';

  @override
  String get notEnoughData =>
      'Henüz yeterli veri yok — bu egzersizi birkaç farklı günde kaydedin.';

  @override
  String get savedExercises => 'Kayıtlı Egzersizler';

  @override
  String get saveExerciseTooltip => 'Egzersizi kaydet';

  @override
  String get unsaveExerciseTooltip => 'Kayıtlılardan kaldır';

  @override
  String get exerciseSavedSnack => 'Egzersiz kaydedildi';

  @override
  String setsCount(int count) {
    return '$count set';
  }
}
