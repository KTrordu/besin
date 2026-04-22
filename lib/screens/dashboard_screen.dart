import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/daily_log.dart';
import '../models/meal.dart';
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: _CalorieSummaryCard(log: log),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _MacroCard(log: log),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Makrolar', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _MacroRow(
              label: 'Protein',
              consumed: log.totalProtein,
              goal: log.goals.protein,
              color: const Color(0xFF64B5F6),
              unit: 'g',
            ),
            const SizedBox(height: 8),
            _MacroRow(
              label: 'Karbonhidrat',
              consumed: log.totalCarbs,
              goal: log.goals.carbs,
              color: const Color(0xFFFFB74D),
              unit: 'g',
            ),
            const SizedBox(height: 8),
            _MacroRow(
              label: 'Yağ',
              consumed: log.totalFat,
              goal: log.goals.fat,
              color: const Color(0xFFEF9A9A),
              unit: 'g',
            ),
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
