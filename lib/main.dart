import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/food_library_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/workout_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/foods_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/workout_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initializeDateFormatting('tr'),
    initializeDateFormatting('en'),
    initializeDateFormatting('fr'),
    initializeDateFormatting('de'),
    initializeDateFormatting('es'),
    initializeDateFormatting('pt'),
  ]);

  final storage = StorageService();
  final nutritionProvider = NutritionProvider(storage: storage);
  final foodLibraryProvider = FoodLibraryProvider(storage: storage);
  final workoutProvider = WorkoutProvider(storage: storage);
  bool initFailed = false;
  try {
    await Future.wait([
      nutritionProvider.init(),
      foodLibraryProvider.init(),
      workoutProvider.init(),
    ]);
  } catch (_) {
    initFailed = true;
  }

  runApp(
    initFailed
        ? const _InitErrorApp()
        : MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: nutritionProvider),
              ChangeNotifierProvider.value(value: foodLibraryProvider),
              ChangeNotifierProvider.value(value: workoutProvider),
            ],
            child: const KaloriTakipApp(),
          ),
  );
}

// ──────────────────────────────────────────────────
// Startup error screen (storage / SharedPreferences failure)
// ──────────────────────────────────────────────────

class _InitErrorApp extends StatelessWidget {
  const _InitErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.dark,
        ),
      ),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 20),
                  Text(
                    'Veriler yüklenirken bir sorun oluştu.\nLütfen uygulamayı yeniden başlatın.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Main app
// ──────────────────────────────────────────────────

class KaloriTakipApp extends StatelessWidget {
  const KaloriTakipApp({super.key});

  static const _seedColor = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Besin :3',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
        Locale('fr'),
        Locale('de'),
        Locale('es'),
        Locale('pt'),
      ],
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
      ),
      home: const _MainNavigation(),
    );
  }
}

class _MainNavigation extends StatefulWidget {
  const _MainNavigation();

  @override
  State<_MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<_MainNavigation> {
  int _currentIndex = 0;

  // Only build a tab on first visit; keep it alive in Offstage afterwards.
  final Set<int> _builtTabs = {0};

  static const _tabWidgets = [
    DashboardScreen(),
    FoodsScreen(),
    WorkoutScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: List.generate(_tabWidgets.length, (i) {
          if (!_builtTabs.contains(i)) return const SizedBox.shrink();
          return Offstage(
            offstage: i != _currentIndex,
            child: TickerMode(
              enabled: i == _currentIndex,
              child: _tabWidgets[i],
            ),
          );
        }),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() {
          _builtTabs.add(i);
          _currentIndex = i;
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.lunch_dining_outlined),
            selectedIcon: const Icon(Icons.lunch_dining),
            label: l10n.navFoods,
          ),
          NavigationDestination(
            icon: const Icon(Icons.fitness_center_outlined),
            selectedIcon: const Icon(Icons.fitness_center),
            label: l10n.navWorkout,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.navStats,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
