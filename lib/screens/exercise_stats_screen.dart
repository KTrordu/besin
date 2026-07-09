import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/workout_provider.dart';

String _formatNum(double v) =>
    v.toStringAsFixed(1).replaceAll(RegExp(r'\.?0+$'), '');

/// Per-exercise progression: max weight and total volume per session as line
/// charts, plus the raw session history.
class ExerciseStatsScreen extends StatefulWidget {
  const ExerciseStatsScreen({super.key, required this.exerciseName});

  final String exerciseName;

  @override
  State<ExerciseStatsScreen> createState() => _ExerciseStatsScreenState();
}

class _ExerciseStatsScreenState extends State<ExerciseStatsScreen> {
  int? _rangeDays = 30;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final allHistory =
        context.watch<WorkoutProvider>().historyFor(widget.exerciseName);
    final history = _rangeDays == null
        ? allHistory
        : allHistory
            .where((h) => h.$1.isAfter(
                DateTime.now().subtract(Duration(days: _rangeDays!))))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text(l10n.last30Days),
                selected: _rangeDays == 30,
                onSelected: (_) => setState(() => _rangeDays = 30),
              ),
              FilterChip(
                label: Text(l10n.last90Days),
                selected: _rangeDays == 90,
                onSelected: (_) => setState(() => _rangeDays = 90),
              ),
              FilterChip(
                label: Text(l10n.allTime),
                selected: _rangeDays == null,
                onSelected: (_) => setState(() => _rangeDays = null),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (history.length < 2)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 64,
                    color: cs.onSurfaceVariant.withAlpha(128),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.notEnoughData,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          else ...[
            _ChartCard(
              title: l10n.maxWeightChart,
              points: [for (final h in history) (h.$1, h.$2.maxWeight)],
              unit: 'kg',
            ),
            const SizedBox(height: 16),
            _ChartCard(
              title: l10n.totalVolumeChart,
              points: [for (final h in history) (h.$1, h.$2.totalVolume)],
              unit: 'kg',
            ),
          ],
          if (history.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.exerciseHistory,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: cs.primary,
                  ),
            ),
            const SizedBox(height: 8),
            for (final h in history.reversed)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(DateFormat(
                    'd MMMM yyyy',
                    Localizations.localeOf(context).languageCode,
                  ).format(h.$1)),
                  subtitle: Text(
                    [
                      for (final s in h.$2.sets)
                        l10n.setSummary(s.reps, _formatNum(s.weightKg)),
                    ].join('  ·  '),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Line chart card (same styling as the weight chart on the stats tab)
// ──────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.points,
    required this.unit,
  });

  final String title;
  final List<(DateTime, double)> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final scaler = MediaQuery.textScalerOf(context);

    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    final spots = <FlSpot>[];
    for (var i = 0; i < points.length; i++) {
      final v = points[i].$2;
      if (v < minY) minY = v;
      if (v > maxY) maxY = v;
      spots.add(FlSpot(i.toDouble(), v));
    }
    final padding = (maxY - minY) < 1 ? 2.0 : (maxY - minY) * 0.15;
    final chartMinY = (minY - padding).floorToDouble().clamp(0, double.infinity).toDouble();
    final chartMaxY = (maxY + padding).ceilToDouble();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 200,
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
                        getDotPainter: (spot, p1, p2, p3) =>
                            FlDotCirclePainter(
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
                        reservedSize: 52,
                        getTitlesWidget: (v, _) => Text(
                          '${_formatNum(v)} $unit',
                          style: TextStyle(
                            fontSize: scaler.scale(9),
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= points.length) {
                            return const SizedBox();
                          }
                          final every =
                              (points.length / 5).ceil().clamp(1, 99);
                          if (idx % every != 0) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              DateFormat('dd/MM').format(points[idx].$1),
                              style: TextStyle(
                                fontSize: scaler.scale(9),
                                color: cs.onSurfaceVariant,
                              ),
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
                              '${_formatNum(s.y)} $unit',
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
          ],
        ),
      ),
    );
  }
}
