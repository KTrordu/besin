import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_l10n_ext.dart';
import '../l10n/app_localizations.dart';
import '../models/daily_log.dart';
import '../providers/nutrition_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _customNutrientCtrl = TextEditingController();

  bool _goalsSaved = false;
  bool _weightSaved = false;
  bool _isExporting = false;
  double? _streakThresholdDraft;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NutritionProvider>(context, listen: false);
    final goals = provider.defaultGoals;
    _caloriesCtrl.text = goals.calories.toStringAsFixed(0);
    _proteinCtrl.text = goals.protein.toStringAsFixed(0);
    _carbsCtrl.text = goals.carbs.toStringAsFixed(0);
    _fatCtrl.text = goals.fat.toStringAsFixed(0);

    final weights = provider.weightLogs;
    if (weights.isNotEmpty) {
      _weightCtrl.text = weights.last.weightKg.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    _weightCtrl.dispose();
    _customNutrientCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveGoals() async {
    if (!_formKey.currentState!.validate()) return;
    final goals = DailyGoals(
      calories: double.parse(_caloriesCtrl.text),
      protein: double.parse(_proteinCtrl.text),
      carbs: double.parse(_carbsCtrl.text),
      fat: double.parse(_fatCtrl.text),
    );
    await context.read<NutritionProvider>().updateDefaultGoals(goals);
    if (!mounted) return;
    setState(() => _goalsSaved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _goalsSaved = false);
    });
  }

  static String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);
    try {
      final provider = context.read<NutritionProvider>();
      final l10n = AppLocalizations.of(context)!;
      final logs = provider.allDailyLogs;
      final dateFmt = DateFormat('yyyy-MM-dd');

      final buf = StringBuffer();
      buf.writeln(
        '${l10n.csvDate},${l10n.csvWorkout},${l10n.csvCheatDay},${l10n.csvWaterMl},'
        '${l10n.csvTotalCalories},${l10n.csvTotalProtein},${l10n.csvTotalCarbs},${l10n.csvTotalFat},'
        '${l10n.csvMealCategory},${l10n.csvMealName},${l10n.calories},${l10n.proteinG},${l10n.carbsG},${l10n.fatG},${l10n.barcode}',
      );

      for (final log in logs) {
        final date = dateFmt.format(log.date);
        final workout = _csvEscape(log.workoutType.l10nName(l10n));
        final cheat = log.isCheatDay ? l10n.csvYes : l10n.csvNo;
        final water = log.waterIntake.toString();
        final totCal = log.totalCalories.toStringAsFixed(0);
        final totPro = log.totalProtein.toStringAsFixed(1);
        final totCarb = log.totalCarbs.toStringAsFixed(1);
        final totFat = log.totalFat.toStringAsFixed(1);

        if (log.meals.isEmpty) {
          buf.writeln('$date,$workout,$cheat,$water,$totCal,$totPro,$totCarb,$totFat,,,,,,');
        } else {
          for (final meal in log.meals) {
            buf.writeln(
              '$date,$workout,$cheat,$water,$totCal,$totPro,$totCarb,$totFat,'
              '${_csvEscape(meal.mealType.l10nName(l10n))},'
              '${_csvEscape(meal.name)},'
              '${meal.calories.toStringAsFixed(0)},'
              '${meal.protein.toStringAsFixed(1)},'
              '${meal.carbs.toStringAsFixed(1)},'
              '${meal.fat.toStringAsFixed(1)},'
              '${meal.barcode ?? ''}',
            );
          }
        }
      }

      final dir = await getTemporaryDirectory();
      final stamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final file = File('${dir.path}/besin_export_$stamp.csv');
      await file.writeAsString(buf.toString(), encoding: utf8);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        subject: 'Besin Verilerim',
      );
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exportFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _saveWeight() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _weightCtrl.text.trim();
    final value = double.tryParse(text);
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invalidWeightValue)),
      );
      return;
    }
    await context.read<NutritionProvider>().addOrUpdateWeight(value);
    if (!mounted) return;
    setState(() => _weightSaved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _weightSaved = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(l10n.settings),
            centerTitle: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      icon: Icons.flag_outlined,
                      title: l10n.dailyGoals,
                    ),
                    const SizedBox(height: 12),
                    _buildGoalField(
                      _caloriesCtrl,
                      l10n.calorieGoal,
                      Icons.local_fire_department_outlined,
                      l10n,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGoalField(
                            _proteinCtrl,
                            l10n.proteinG,
                            null,
                            l10n,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGoalField(
                            _carbsCtrl,
                            l10n.carbsG,
                            null,
                            l10n,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGoalField(
                            _fatCtrl,
                            l10n.fatG,
                            null,
                            l10n,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _saveGoals,
                      icon: Icon(
                        _goalsSaved ? Icons.check : Icons.save_outlined,
                      ),
                      label: Text(_goalsSaved ? l10n.saved : l10n.saveGoals),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _SectionHeader(
                      icon: Icons.monitor_weight_outlined,
                      title: l10n.currentWeight,
                    ),
                    const SizedBox(height: 12),
                    _WeightCard(
                      controller: _weightCtrl,
                      onSave: _saveWeight,
                      saved: _weightSaved,
                      provider: context.watch<NutritionProvider>(),
                    ),
                    const SizedBox(height: 32),
                    _SectionHeader(
                      icon: Icons.tune_outlined,
                      title: l10n.appSettings,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      margin: EdgeInsets.zero,
                      child: SwitchListTile(
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 4, 12, 4),
                        secondary:
                            const Icon(Icons.fitness_center_outlined),
                        title: Text(l10n.showWorkoutTracking),
                        subtitle: Text(l10n.showWorkoutTrackingSub),
                        value: context
                            .watch<NutritionProvider>()
                            .enableWorkoutTracking,
                        onChanged: (val) => context
                            .read<NutritionProvider>()
                            .setEnableWorkoutTracking(val),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                            child: Text(
                              l10n.macrosToTrack,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SwitchListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 0, 12, 0),
                            secondary: const Icon(Icons.egg_outlined),
                            title: Text(l10n.protein),
                            value: context
                                .watch<NutritionProvider>()
                                .trackProtein,
                            onChanged: (val) => context
                                .read<NutritionProvider>()
                                .setTrackProtein(val),
                          ),
                          SwitchListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 0, 12, 0),
                            secondary: const Icon(Icons.grain_outlined),
                            title: Text(l10n.carbs),
                            value: context
                                .watch<NutritionProvider>()
                                .trackCarbs,
                            onChanged: (val) => context
                                .read<NutritionProvider>()
                                .setTrackCarbs(val),
                          ),
                          SwitchListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 0, 12, 0),
                            secondary:
                                const Icon(Icons.water_drop_outlined),
                            title: Text(l10n.fat),
                            value:
                                context.watch<NutritionProvider>().trackFat,
                            onChanged: (val) => context
                                .read<NutritionProvider>()
                                .setTrackFat(val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CustomNutrientsCard(
                      provider: context.watch<NutritionProvider>(),
                      controller: _customNutrientCtrl,
                      onAdd: () async {
                        FocusScope.of(context).unfocus();
                        await context
                            .read<NutritionProvider>()
                            .addCustomNutrient(_customNutrientCtrl.text);
                        _customNutrientCtrl.clear();
                      },
                      onRemove: (name) => context
                          .read<NutritionProvider>()
                          .removeCustomNutrient(name),
                    ),
                    const SizedBox(height: 32),
                    _SectionHeader(
                      icon: Icons.local_fire_department_outlined,
                      title: l10n.streakRules,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.streakRulesSub,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 12, 12, 4),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.streakFlexibility(
                                    ((_streakThresholdDraft ??
                                                context
                                                    .watch<NutritionProvider>()
                                                    .streakThreshold) *
                                            100)
                                        .round(),
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                                Slider(
                                  value: _streakThresholdDraft ??
                                      context
                                          .watch<NutritionProvider>()
                                          .streakThreshold,
                                  min: 0.50,
                                  max: 1.00,
                                  divisions: 10,
                                  label: l10n.streakFlexibility(
                                    ((_streakThresholdDraft ??
                                                context
                                                    .watch<NutritionProvider>()
                                                    .streakThreshold) *
                                            100)
                                        .round(),
                                  ),
                                  onChanged: (val) => setState(
                                      () => _streakThresholdDraft = val),
                                  onChangeEnd: (val) {
                                    setState(() =>
                                        _streakThresholdDraft = null);
                                    context
                                        .read<NutritionProvider>()
                                        .updateStreakThreshold(val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 0, 12, 0),
                            secondary: const Icon(
                                Icons.local_fire_department_outlined),
                            title: Text(l10n.calorieGoalLabel),
                            subtitle: Text(l10n.calorieGoalRequired),
                            value: context
                                .watch<NutritionProvider>()
                                .streakRequireCalories,
                            onChanged: (val) => context
                                .read<NutritionProvider>()
                                .setStreakRequireCalories(val),
                          ),
                          SwitchListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 0, 12, 0),
                            secondary: const Icon(Icons.egg_outlined),
                            title: Text(l10n.proteinGoalLabel),
                            subtitle: Text(l10n.proteinGoalRequired),
                            value: context
                                .watch<NutritionProvider>()
                                .streakRequireProtein,
                            onChanged: (val) => context
                                .read<NutritionProvider>()
                                .setStreakRequireProtein(val),
                          ),
                          SwitchListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 0, 12, 0),
                            secondary: const Icon(Icons.grain_outlined),
                            title: Text(l10n.carbsGoalLabel),
                            subtitle: Text(l10n.carbsGoalRequired),
                            value: context
                                .watch<NutritionProvider>()
                                .streakRequireCarbs,
                            onChanged: (val) => context
                                .read<NutritionProvider>()
                                .setStreakRequireCarbs(val),
                          ),
                          SwitchListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 0, 12, 0),
                            secondary:
                                const Icon(Icons.water_drop_outlined),
                            title: Text(l10n.fatGoalLabel),
                            subtitle: Text(l10n.fatGoalRequired),
                            value: context
                                .watch<NutritionProvider>()
                                .streakRequireFat,
                            onChanged: (val) => context
                                .read<NutritionProvider>()
                                .setStreakRequireFat(val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _SectionHeader(
                      icon: Icons.download_outlined,
                      title: l10n.dataManagement,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _isExporting ? null : _exportCsv,
                      icon: _isExporting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.table_chart_outlined),
                      label: Text(
                        _isExporting ? l10n.exporting : l10n.exportCsv,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalField(
    TextEditingController ctrl,
    String label,
    IconData? icon,
    AppLocalizations l10n,
  ) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return l10n.cannotBeEmpty;
        final n = double.tryParse(v.trim());
        if (n == null || n <= 0) return l10n.invalidValue;
        return null;
      },
    );
  }
}

// ──────────────────────────────────────────────────
// Sub-widgets
// ──────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _WeightCard extends StatelessWidget {
  const _WeightCard({
    required this.controller,
    required this.onSave,
    required this.saved,
    required this.provider,
  });

  final TextEditingController controller;
  final VoidCallback onSave;
  final bool saved;
  final NutritionProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weights = provider.weightLogs;
    final lastWeight = weights.isNotEmpty
        ? '${weights.last.weightKg.toStringAsFixed(1)} kg'
        : '-';
    final firstWeight = weights.isNotEmpty
        ? '${weights.first.weightKg.toStringAsFixed(1)} kg'
        : '-';
    final diff = weights.length >= 2
        ? weights.last.weightKg - weights.first.weightKg
        : null;

    return Column(
      children: [
        if (weights.isNotEmpty)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(label: l10n.startWeight, value: firstWeight),
                  _StatItem(label: l10n.currentWeightLabel, value: lastWeight),
                  if (diff != null)
                    _StatItem(
                      label: l10n.weightChange,
                      value:
                          '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg',
                      valueColor: diff <= 0
                          ? const Color(0xFF66BB6A)
                          : Theme.of(context).colorScheme.error,
                    ),
                ],
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.todayWeight,
                  prefixIcon: const Icon(Icons.scale_outlined),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: onSave,
              icon: Icon(saved ? Icons.check : Icons.save_outlined),
              label: Text(saved ? l10n.saved : l10n.save),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 56),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomNutrientsCard extends StatelessWidget {
  const _CustomNutrientsCard({
    required this.provider,
    required this.controller,
    required this.onAdd,
    required this.onRemove,
  });

  final NutritionProvider provider;
  final TextEditingController controller;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final nutrients = provider.customNutrients;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.customNutrients,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: cs.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.customNutrientsSub,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
            if (nutrients.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: nutrients
                    .map(
                      (n) => Chip(
                        label: Text(n),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => onRemove(n),
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.newNutrientHint,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    onSubmitted: (_) => onAdd(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(l10n.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
