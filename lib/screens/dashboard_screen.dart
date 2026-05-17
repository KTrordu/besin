import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/daily_log.dart';
import '../models/meal.dart';
import '../models/streak.dart';
import '../providers/nutrition_provider.dart';
import 'add_edit_meal_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final log = provider.currentDailyLog;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const SliverAppBar.large(
                title: Text('Kalori Takip'),
                centerTitle: false,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _DateSelector(
                    date: provider.selectedDate,
                    onChanged: provider.selectDate,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _StreakBanner(
                  streakData: provider.streakData,
                  todayGoalsMet: provider.todayGoalsMet,
                ),
              ),
              if (log.isCheatDay)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: _CheatDayBanner(),
                  ),
                )
              else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: _CalorieSummaryCard(log: log),
                  ),
                ),
                if (provider.trackProtein ||
                    provider.trackCarbs ||
                    provider.trackFat)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: _MacroCard(log: log),
                    ),
                  ),
              ],
              if (log.totalExtraNutrients.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: _ExtraNutrientsBar(
                        nutrients: log.totalExtraNutrients),
                  ),
                ),
              if (provider.enableWorkoutTracking)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _WorkoutSelector(provider: provider),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _CheatDayToggle(provider: provider),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _WaterTrackerCard(provider: provider),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              for (final type in MealType.values)
                _MealTypeSection(
                  log: log,
                  type: type,
                  provider: provider,
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditMealScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Öğün Ekle'),
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────
// Date Selector
// ──────────────────────────────────────────────────

class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.date, required this.onChanged});

  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(date);
    final formatter = DateFormat('d MMMM yyyy, EEEE', 'tr_TR');
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => onChanged(date.subtract(const Duration(days: 1))),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) onChanged(picked);
                },
                child: Column(
                  children: [
                    Text(
                      formatter.format(date),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (isToday)
                      Text(
                        'Bugün',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => onChanged(date.add(const Duration(days: 1))),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}

// ──────────────────────────────────────────────────
// Calorie Summary Card
// ──────────────────────────────────────────────────

class _CalorieSummaryCard extends StatelessWidget {
  const _CalorieSummaryCard({required this.log});

  final DailyLog log;

  @override
  Widget build(BuildContext context) {
    final consumed = log.totalCalories;
    final goal = log.goals.calories;
    final remaining = goal - consumed;
    final progress = (consumed / goal).clamp(0.0, 1.0);
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kalori',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${consumed.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)} kcal',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: cs.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(
                  progress >= 1.0 ? cs.error : cs.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              remaining >= 0
                  ? '${remaining.toStringAsFixed(0)} kcal kaldı'
                  : '${(-remaining).toStringAsFixed(0)} kcal aşıldı',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: remaining >= 0 ? cs.onSurfaceVariant : cs.error,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Macro Progress Card
// ──────────────────────────────────────────────────

class _MacroCard extends StatelessWidget {
  const _MacroCard({required this.log});

  final DailyLog log;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NutritionProvider>();
    final rows = <Widget>[];

    if (provider.trackProtein) {
      rows.add(_MacroRow(
        label: 'Protein',
        consumed: log.totalProtein,
        goal: log.goals.protein,
        color: const Color(0xFF64B5F6),
        unit: 'g',
      ));
    }
    if (provider.trackCarbs) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 8));
      rows.add(_MacroRow(
        label: 'Karbonhidrat',
        consumed: log.totalCarbs,
        goal: log.goals.carbs,
        color: const Color(0xFFFFB74D),
        unit: 'g',
      ));
    }
    if (provider.trackFat) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 8));
      rows.add(_MacroRow(
        label: 'Yağ',
        consumed: log.totalFat,
        goal: log.goals.fat,
        color: const Color(0xFFEF9A9A),
        unit: 'g',
      ));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Makrolar', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.label,
    required this.consumed,
    required this.goal,
    required this.color,
    required this.unit,
  });

  final String label;
  final double consumed;
  final double goal;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${consumed.toStringAsFixed(1)} / ${goal.toStringAsFixed(0)} $unit',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────
// Meal Type Section
// ──────────────────────────────────────────────────

class _MealTypeSection extends StatelessWidget {
  const _MealTypeSection({
    required this.log,
    required this.type,
    required this.provider,
  });

  final DailyLog log;
  final MealType type;
  final NutritionProvider provider;

  static const _icons = {
    MealType.breakfast: Icons.wb_sunny_outlined,
    MealType.lunch: Icons.wb_cloudy_outlined,
    MealType.dinner: Icons.nights_stay_outlined,
    MealType.snack: Icons.apple,
    MealType.extra: Icons.cookie_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final meals = log.meals.where((m) => m.mealType == type).toList();
    if (meals.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    final sectionCalories =
        '${meals.fold(0.0, (s, m) => s + m.calories).toStringAsFixed(0)} kcal';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _icons[type],
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  type.displayName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 6),
                Text(
                  sectionCalories,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...meals.map(
              (m) => _MealTile(
                meal: m,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditMealScreen(meal: m),
                  ),
                ),
                onDelete: () => _confirmDelete(context, m.id),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String mealId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Öğünü Sil'),
        content: const Text('Bu öğünü silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.deleteMeal(mealId);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Meal Tile
// ──────────────────────────────────────────────────

class _MealTile extends StatelessWidget {
  const _MealTile({
    required this.meal,
    required this.onEdit,
    required this.onDelete,
  });

  final Meal meal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
        title: Text(
          meal.name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          'P: ${meal.protein.toStringAsFixed(1)}g  '
          'K: ${meal.carbs.toStringAsFixed(1)}g  '
          'Y: ${meal.fat.toStringAsFixed(1)}g',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: cs.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  meal.calories.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'kcal',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                PopupMenuItem(value: 'delete', child: Text('Sil')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Streak Banner
// ──────────────────────────────────────────────────

class _StreakBanner extends StatelessWidget {
  const _StreakBanner({
    required this.streakData,
    required this.todayGoalsMet,
  });

  final StreakData streakData;
  final bool todayGoalsMet;

  @override
  Widget build(BuildContext context) {
    final streak = streakData.currentStreak;
    if (streak == 0) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    const flameOrange = Color(0xFFFF8F00);
    const flameDark = Color(0xFFE65100);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              flameDark.withAlpha(38),
              flameOrange.withAlpha(18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: flameOrange.withAlpha(100)),
          boxShadow: [
            BoxShadow(
              color: flameOrange.withAlpha(46),
              blurRadius: 18,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Alev ikonu (parlayan çember)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: flameOrange.withAlpha(46),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: flameOrange.withAlpha(80),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_fire_department,
                size: 26,
                color: flameOrange,
              ),
            ),
            const SizedBox(width: 12),

            // Metin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title(streak),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: flameOrange,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle(streak, todayGoalsMet),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),

            // En uzun seri rozeti
            if (streakData.longestStreak > 1)
              Column(
                children: [
                  Text(
                    '${streakData.longestStreak}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: flameOrange.withAlpha(180),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Rekor',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _title(int streak) {
    if (streak >= 30) return '$streak Günlük Seri 🏆';
    if (streak >= 7) return '$streak Günlük Seri 🌟';
    return '$streak Günlük Seri';
  }

  String _subtitle(int streak, bool todayGoalsMet) {
    if (!todayGoalsMet) return 'Seriyi sürdürmek için bugün hedeflere ulaş!';
    if (streak == 1) return 'Harika başlangıç! Yarın da devam et!';
    if (streak < 7) return '${7 - streak} gün daha — haftalık seriye ulaş!';
    if (streak < 30) return 'Müthiş! ${30 - streak} gün daha — aylık seriye!';
    return 'Efsanevi bir serin var, öyle devam et! 🎉';
  }
}

// ──────────────────────────────────────────────────
// Water Tracker Card
// ──────────────────────────────────────────────────

class _WaterTrackerCard extends StatelessWidget {
  const _WaterTrackerCard({required this.provider});

  final NutritionProvider provider;

  static const _goalMl = 2000;
  static const _stepMl = 250;
  static const _waterBlue = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    final intake = provider.currentDailyLog.waterIntake;
    final progress = (intake / _goalMl).clamp(0.0, 1.0);
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop_outlined,
                    color: _waterBlue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Su Takibi',
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                Text(
                  '$intake / $_goalMl ml',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: cs.surfaceContainerHighest,
                valueColor: const AlwaysStoppedAnimation(_waterBlue),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progress >= 1.0
                      ? 'Günlük hedefe ulaştın! 💧'
                      : '${_goalMl - intake} ml kaldı',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
                Row(
                  children: [
                    if (intake > 0)
                      TextButton(
                        onPressed: () => provider.addWater(-_stepMl),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                        ),
                        child: const Text('-$_stepMl ml'),
                      ),
                    const SizedBox(width: 4),
                    FilledButton.icon(
                      onPressed: () => provider.addWater(_stepMl),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('+$_stepMl ml'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _waterBlue,
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Cheat Day Banner
// ──────────────────────────────────────────────────

class _CheatDayBanner extends StatelessWidget {
  const _CheatDayBanner();

  @override
  Widget build(BuildContext context) {
    const goldDark = Color(0xFFFF8F00);
    const goldLight = Color(0xFFFFD54F);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [goldDark.withAlpha(60), goldLight.withAlpha(30)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: goldDark.withAlpha(120)),
        boxShadow: [
          BoxShadow(
            color: goldDark.withAlpha(60),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🍔', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          Text(
            'Bugün Cheat Day!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: goldDark,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Bugün makroları dert etme, afiyet olsun! 🎉',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Cheat Day Toggle
// ──────────────────────────────────────────────────

class _CheatDayToggle extends StatelessWidget {
  const _CheatDayToggle({required this.provider});

  final NutritionProvider provider;

  @override
  Widget build(BuildContext context) {
    final isCheat = provider.currentDailyLog.isCheatDay;
    const goldDark = Color(0xFFFF8F00);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCheat
            ? BorderSide(color: goldDark.withAlpha(150), width: 1.5)
            : BorderSide.none,
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
        title: Row(
          children: [
            Text(
              'Cheat Day',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isCheat ? goldDark : null,
                    fontWeight: isCheat ? FontWeight.bold : null,
                  ),
            ),
            if (isCheat) ...[
              const SizedBox(width: 6),
              const Text('🍔'),
            ],
          ],
        ),
        subtitle: Text(
          isCheat
              ? 'Hedefler ve seri korunuyor'
              : 'Seriyi bozmadan kaçamak yap',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        value: isCheat,
        onChanged: (val) => provider.updateCheatDay(val),
        activeThumbColor: goldDark,
        activeTrackColor: goldDark.withAlpha(100),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Extra Nutrients Bar
// ──────────────────────────────────────────────────

class _ExtraNutrientsBar extends StatelessWidget {
  const _ExtraNutrientsBar({required this.nutrients});

  final Map<String, double> nutrients;

  @override
  Widget build(BuildContext context) {
    final visibleEntries =
        nutrients.entries.where((e) => e.value > 0).toList();
    if (visibleEntries.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: visibleEntries
          .map(
            (e) => Chip(
              avatar: const Icon(Icons.science_outlined, size: 14),
              label: Text(
                '${e.key}: ${e.value.toStringAsFixed(1)} g',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }
}

// ──────────────────────────────────────────────────
// Workout Selector
// ──────────────────────────────────────────────────

class _WorkoutSelector extends StatelessWidget {
  const _WorkoutSelector({required this.provider});

  final NutritionProvider provider;

  static const _icons = {
    WorkoutType.push: Icons.fitness_center,
    WorkoutType.pull: Icons.sports,
    WorkoutType.legs: Icons.directions_run,
    WorkoutType.rest: Icons.bedtime_outlined,
    WorkoutType.light: Icons.directions_walk,
    WorkoutType.upperBody: Icons.accessibility_new_outlined,
    WorkoutType.lowerBody: Icons.airline_seat_legroom_extra_outlined,
    WorkoutType.none: Icons.radio_button_unchecked,
  };

  // Display order keeps "Belirtilmedi" last regardless of enum declaration order.
  static const _displayOrder = [
    WorkoutType.push,
    WorkoutType.pull,
    WorkoutType.legs,
    WorkoutType.upperBody,
    WorkoutType.lowerBody,
    WorkoutType.rest,
    WorkoutType.light,
    WorkoutType.none,
  ];

  @override
  Widget build(BuildContext context) {
    final selected = provider.currentDailyLog.workoutType;
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fitness_center, size: 16, color: cs.primary),
                const SizedBox(width: 8),
                Text('Antrenman',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _displayOrder.map((type) {
                return ChoiceChip(
                  avatar: Icon(_icons[type], size: 14),
                  label: Text(type.displayName),
                  selected: selected == type,
                  onSelected: (_) => provider.updateWorkoutType(type),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
