import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/nutrition_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';

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
  final provider = NutritionProvider();
  await provider.init();
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const KaloriTakipApp(),
    ),
  );
}

class KaloriTakipApp extends StatelessWidget {
  const KaloriTakipApp({super.key});

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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
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

  static const _screens = [
    DashboardScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navToday,
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
