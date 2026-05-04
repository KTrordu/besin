import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/daily_log.dart';
import '../models/weight_log.dart';
import '../providers/nutrition_provider.dart';

// Shared macro colours used by bar chart, pie chart and legend
const _kProteinColor = Color(0xFF64B5F6);
const _kCarbsColor = Color(0xFFFFB74D);
const _kFatColor = Color(0xFFEF9A9A);

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, provider, _) {
        final recentLogs = provider.getRecentLogs(14);
        final weightLogs = provider.weightLogs;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const SliverAppBar.large(
                title: Text('İstatistikler'),
                centerTitle: false,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(
                        title: 'Kalori Geçmişi (14 Gün)',
                        icon: Icons.bar_chart,
                      ),
                      const SizedBox(height: 12),
                      _CalorieBarChart(logs: recentLogs),
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: 'Makro Geçmişi (7 Gün)',
                        icon: Icons.pie_chart_outline,
                      ),
                      const SizedBox(height: 12),
                      _MacroBarChart(logs: provider.getRecentLogs(7)),
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: 'Günlük Makro Dağılımı',
                        icon: Icons.donut_large_outlined,
                      ),
                      const SizedBox(height: 12),
                      _MacroPieChart(log: provider.currentDailyLog),
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: 'Kilo Takibi',
                        icon: Icons.show_chart,
                      ),
                      const SizedBox(height: 12),
                      if (weightLogs.length < 2)
                        _EmptyChartPlaceholder(
                          message: weightLogs.isEmpty
                              ? 'Henüz kilo verisi yok.\nAyarlar ekranından kilo ekleyebilirsiniz.'
                              : 'Grafik için en az 2 ölçüm gereklidir.',
                        )
                      else
                        _WeightLineChart(logs: weightLogs.toList()),
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: 'Antrenman – Makro Korelasyonu (30 Gün)',
                        icon: Icons.analytics_outlined,
                      ),
                      const SizedBox(height: 12),
                      _WorkoutCorrelationCard(
                        logsByType: provider.getLogsByWorkoutType(30),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────
// Section Title
// ──────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

// ──────────────────────────────────────────────────
// Empty Placeholder
// ──────────────────────────────────────────────────

class _EmptyChartPlaceholder extends StatelessWidget {
  const _EmptyChartPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 160,
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Calorie Bar Chart (14 days)
// ──────────────────────────────────────────────────

class _CalorieBarChart extends StatelessWidget {
  const _CalorieBarChart({required this.logs});

  final List<DailyLog> logs;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxY = logs.fold<double>(
          0,
          (m, l) => l.goals.calories > m ? l.goals.calories : m,
        ) *
        1.3;

    final groups = logs.asMap().entries.map((e) {
      final consumed = e.value.totalCalories;
      final goal = e.value.goals.calories;
      final overGoal = consumed > goal;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: consumed,
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            color: overGoal ? cs.error : cs.primary,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: goal,
              color: cs.surfaceContainerHighest,
            ),
          ),
        ],
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barGroups: groups,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 500,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: cs.outlineVariant,
                  strokeWidth: 0.5,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    interval: 500,
                    getTitlesWidget: (v, _) => Text(
                      v.toInt().toString(),
                      style: TextStyle(
                          fontSize: 10, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, _) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= logs.length) return const SizedBox();
                      final d = logs[idx].date;
                      final isEven = idx % 2 == 0;
                      if (!isEven) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat('dd/MM').format(d),
                          style: TextStyle(
                              fontSize: 9, color: cs.onSurfaceVariant),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final log = logs[group.x.toInt()];
                    return BarTooltipItem(
                      '${log.totalCalories.toStringAsFixed(0)} kcal\n',
                      TextStyle(
                          color: cs.onSurface, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: 'Hedef: ${log.goals.calories.toStringAsFixed(0)}',
                          style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.normal,
                              fontSize: 11),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Macro Bar Chart (7 days)
// ──────────────────────────────────────────────────

class _MacroBarChart extends StatelessWidget {
  const _MacroBarChart({required this.logs});

  final List<DailyLog> logs;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final groups = logs.asMap().entries.map((e) {
      final l = e.value;
      return BarChartGroupData(
        x: e.key,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
            toY: l.totalProtein,
            width: 8,
            color: _kProteinColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          BarChartRodData(
            toY: l.totalCarbs,
            width: 8,
            color: _kCarbsColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          BarChartRodData(
            toY: l.totalFat,
            width: 8,
            color: _kFatColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(3)),
          ),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Legend(color: _kProteinColor, label: 'Protein'),
            const SizedBox(width: 16),
            _Legend(color: _kCarbsColor, label: 'Karbonhidrat'),
            const SizedBox(width: 16),
            _Legend(color: _kFatColor, label: 'Yağ'),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
            child: SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: groups,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (v) => FlLine(
                      color: cs.outlineVariant,
                      strokeWidth: 0.5,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text(
                          '${v.toInt()}g',
                          style: TextStyle(
                              fontSize: 9, color: cs.onSurfaceVariant),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= logs.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              DateFormat('dd/MM').format(logs[idx].date),
                              style: TextStyle(
                                  fontSize: 9, color: cs.onSurfaceVariant),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

// ──────────────────────────────────────────────────
// Weight Line Chart
// ──────────────────────────────────────────────────

class _WeightLineChart extends StatelessWidget {
  const _WeightLineChart({required this.logs});

  final List<WeightLog> logs;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    final spots = logs.asMap().entries.map((e) {
      final w = e.value.weightKg;
      if (w < minY) minY = w;
      if (w > maxY) maxY = w;
      return FlSpot(e.key.toDouble(), w);
    }).toList();

    final padding = (maxY - minY) < 1 ? 2.0 : (maxY - minY) * 0.15;
    final chartMinY = (minY - padding).floorToDouble();
    final chartMaxY = (maxY + padding).ceilToDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minY: chartMinY,
              maxY: chartMaxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: cs.primary,
                  barWidth: 2.5,
                  dotData: FlDotData(
                    getDotPainter: (spot, p1, p2, p3) => FlDotCirclePainter(
                      radius: 4,
                      color: cs.primary,
                      strokeWidth: 2,
                      strokeColor: cs.surface,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: cs.primary.withAlpha(30),
                  ),
                ),
              ],
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: cs.outlineVariant,
                  strokeWidth: 0.5,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (v, _) => Text(
                      '${v.toStringAsFixed(1)} kg',
                      style: TextStyle(
                          fontSize: 9, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, _) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= logs.length) return const SizedBox();
                      final every = (logs.length / 5).ceil().clamp(1, 99);
                      if (idx % every != 0) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat('dd/MM').format(logs[idx].date),
                          style: TextStyle(
                              fontSize: 9, color: cs.onSurfaceVariant),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots
                      .map(
                        (s) => LineTooltipItem(
                          '${s.y.toStringAsFixed(1)} kg',
                          TextStyle(
                            color: cs.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Macro Pie Chart (selected day)
// ──────────────────────────────────────────────────

class _MacroPieChart extends StatelessWidget {
  const _MacroPieChart({required this.log});

  final DailyLog log;

  @override
  Widget build(BuildContext context) {
    final proteinKcal = log.totalProtein * 4;
    final carbsKcal = log.totalCarbs * 4;
    final fatKcal = log.totalFat * 9;
    final total = proteinKcal + carbsKcal + fatKcal;

    if (total < 1) {
      return const _EmptyChartPlaceholder(
        message: 'Bu gün için henüz besin kaydı yok.',
      );
    }

    String pctTitle(double kcal) {
      final pct = kcal / total * 100;
      return pct >= 10 ? '${pct.toStringAsFixed(0)}%' : '';
    }

    const titleStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              height: 180,
              width: 180,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: proteinKcal,
                      color: _kProteinColor,
                      title: pctTitle(proteinKcal),
                      titleStyle: titleStyle,
                      radius: 72,
                    ),
                    PieChartSectionData(
                      value: carbsKcal,
                      color: _kCarbsColor,
                      title: pctTitle(carbsKcal),
                      titleStyle: titleStyle,
                      radius: 72,
                    ),
                    PieChartSectionData(
                      value: fatKcal,
                      color: _kFatColor,
                      title: pctTitle(fatKcal),
                      titleStyle: titleStyle,
                      radius: 72,
                    ),
                  ],
                  sectionsSpace: 3,
                  centerSpaceRadius: 32,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PieLegendRow(
                    color: _kProteinColor,
                    label: 'Protein',
                    grams: log.totalProtein,
                    kcal: proteinKcal,
                  ),
                  const SizedBox(height: 10),
                  _PieLegendRow(
                    color: _kCarbsColor,
                    label: 'Karbonhidrat',
                    grams: log.totalCarbs,
                    kcal: carbsKcal,
                  ),
                  const SizedBox(height: 10),
                  _PieLegendRow(
                    color: _kFatColor,
                    label: 'Yağ',
                    grams: log.totalFat,
                    kcal: fatKcal,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Toplam: ${total.toStringAsFixed(0)} kcal',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PieLegendRow extends StatelessWidget {
  const _PieLegendRow({
    required this.color,
    required this.label,
    required this.grams,
    required this.kcal,
  });

  final Color color;
  final String label;
  final double grams;
  final double kcal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                '${grams.toStringAsFixed(1)}g · ${kcal.toStringAsFixed(0)} kcal',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────
// Workout – Macro Correlation Card (30 days)
// ──────────────────────────────────────────────────

class _WorkoutCorrelationCard extends StatelessWidget {
  const _WorkoutCorrelationCard({required this.logsByType});

  final Map<WorkoutType, List<DailyLog>> logsByType;

  static const _icons = {
    WorkoutType.push: Icons.fitness_center,
    WorkoutType.pull: Icons.sports,
    WorkoutType.legs: Icons.directions_run,
    WorkoutType.rest: Icons.bedtime_outlined,
    WorkoutType.light: Icons.directions_walk,
  };

  @override
  Widget build(BuildContext context) {
    if (logsByType.isEmpty) {
      return const _EmptyChartPlaceholder(
        message: "Antrenman verisi yok.\nDashboard'dan antrenman tipi seçin.",
      );
    }

    final orderedTypes = [
      WorkoutType.push,
      WorkoutType.pull,
      WorkoutType.legs,
      WorkoutType.rest,
      WorkoutType.light,
    ].where(logsByType.containsKey).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < orderedTypes.length; i++) ...[
              _WorkoutTypeRow(
                type: orderedTypes[i],
                icon: _icons[orderedTypes[i]]!,
                logs: logsByType[orderedTypes[i]]!,
              ),
              if (i < orderedTypes.length - 1) const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _WorkoutTypeRow extends StatelessWidget {
  const _WorkoutTypeRow({
    required this.type,
    required this.icon,
    required this.logs,
  });

  final WorkoutType type;
  final IconData icon;
  final List<DailyLog> logs;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final count = logs.length;
    final avgProtein =
        logs.fold(0.0, (s, l) => s + l.totalProtein / l.goals.protein) /
            count;
    final avgCarbs =
        logs.fold(0.0, (s, l) => s + l.totalCarbs / l.goals.carbs) / count;
    final avgFat =
        logs.fold(0.0, (s, l) => s + l.totalFat / l.goals.fat) / count;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: cs.primary),
            const SizedBox(width: 6),
            Text(
              '${type.displayName}  ($count gün)',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: cs.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _CorrelationRow(label: 'Protein', rate: avgProtein),
        const SizedBox(height: 5),
        _CorrelationRow(label: 'Karbonhidrat', rate: avgCarbs),
        const SizedBox(height: 5),
        _CorrelationRow(label: 'Yağ', rate: avgFat),
      ],
    );
  }
}

class _CorrelationRow extends StatelessWidget {
  const _CorrelationRow({required this.label, required this.rate});

  final String label;
  final double rate; // actual / goal ratio

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pct = (rate * 100).round().clamp(0, 999);
    final color = rate >= 0.85
        ? const Color(0xFF66BB6A)
        : rate >= 0.60
            ? _kCarbsColor
            : cs.error;

    return Row(
      children: [
        SizedBox(
          width: 88,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: rate.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '%$pct',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: color),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
