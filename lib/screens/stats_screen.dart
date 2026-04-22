import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/daily_log.dart';
import '../models/weight_log.dart';
import '../providers/nutrition_provider.dart';

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
            color: const Color(0xFF64B5F6),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          BarChartRodData(
            toY: l.totalCarbs,
            width: 8,
            color: const Color(0xFFFFB74D),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          BarChartRodData(
            toY: l.totalFat,
            width: 8,
            color: const Color(0xFFEF9A9A),
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
            _Legend(color: const Color(0xFF64B5F6), label: 'Protein'),
            const SizedBox(width: 16),
            _Legend(color: const Color(0xFFFFB74D), label: 'Karbonhidrat'),
            const SizedBox(width: 16),
            _Legend(color: const Color(0xFFEF9A9A), label: 'Yağ'),
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
