import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise_log.dart';
import '../providers/workout_provider.dart';
import '../widgets/date_selector.dart';
import 'exercise_stats_screen.dart';

String _formatNum(double v) =>
    v.toStringAsFixed(1).replaceAll(RegExp(r'\.?0+$'), '');

/// Workout tab: per-day exercise log (sets × reps × weight) with free-text
/// exercise names suggested from history.
class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  Future<void> _addExercise(BuildContext context) async {
    final provider = context.read<WorkoutProvider>();
    final entry = await showModalBottomSheet<ExerciseEntry>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddExerciseSheet(
        knownNames: provider.knownExerciseNames,
      ),
    );
    if (entry == null) return;
    await provider.addEntry(entry);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<WorkoutProvider>();
    final entries = provider.currentEntries;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(l10n.navWorkout),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            sliver: SliverToBoxAdapter(
              child: DateSelector(
                date: provider.selectedDate,
                onChanged: provider.selectDate,
              ),
            ),
          ),
          if (entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withAlpha(128),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noExercisesToday,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
              sliver: SliverList.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) =>
                    _ExerciseCard(entry: entries[index]),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addExercise(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addExercise),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Exercise entry card
// ──────────────────────────────────────────────────

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.entry});

  final ExerciseEntry entry;

  Future<void> _delete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteExercise),
        content: Text(l10n.deleteExerciseConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<WorkoutProvider>().deleteEntry(entry.id);
  }

  Future<void> _addSet(BuildContext context) async {
    final set = await showModalBottomSheet<ExerciseSet>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _SetEditorSheet(),
    );
    if (set == null || !context.mounted) return;
    await context.read<WorkoutProvider>().addSet(entry.id, set);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.show_chart, size: 20),
                  tooltip: l10n.exerciseProgress,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ExerciseStatsScreen(exerciseName: entry.name),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 20, color: cs.error),
                  onPressed: () => _delete(context),
                ),
              ],
            ),
            for (var i = 0; i < entry.sets.length; i++)
              Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${i + 1}.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.setSummary(
                        entry.sets[i].reps,
                        _formatNum(entry.sets[i].weightKg),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => context
                        .read<WorkoutProvider>()
                        .removeSet(entry.id, i),
                  ),
                ],
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _addSet(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.addSet),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Add-exercise bottom sheet (name + first set)
// ──────────────────────────────────────────────────

class _AddExerciseSheet extends StatefulWidget {
  const _AddExerciseSheet({required this.knownNames});

  final List<String> knownNames;

  @override
  State<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<_AddExerciseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  // Suggestions from history, shown as chips below the field (more reliable
  // than an Autocomplete overlay inside a bottom sheet with the keyboard up).
  List<String> get _suggestions {
    final query = _nameCtrl.text.trim().toLowerCase();
    final matches = query.isEmpty
        ? widget.knownNames
        : widget.knownNames
            .where((n) => n.toLowerCase().contains(query))
            .toList();
    return matches.where((n) => n.toLowerCase() != query).take(6).toList();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final reps =
        int.tryParse(_repsCtrl.text.trim()) ?? 0;
    final weight =
        double.tryParse(_weightCtrl.text.trim().replaceAll(',', '.')) ?? 0;
    Navigator.pop(
      context,
      ExerciseEntry(
        id: 'ex_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameCtrl.text.trim(),
        sets: [ExerciseSet(reps: reps, weightKg: weight)],
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final suggestions = _suggestions;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.addExercise,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.exerciseName,
                prefixIcon: const Icon(Icons.fitness_center),
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l10n.cannotBeEmpty : null,
            ),
            if (suggestions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final name in suggestions)
                    ActionChip(
                      label: Text(name),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        _nameCtrl.text = name;
                        _nameCtrl.selection = TextSelection.collapsed(
                            offset: name.length);
                      },
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _repsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.reps,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.cannotBeEmpty;
                      }
                      final n = int.tryParse(v.trim());
                      if (n == null) return l10n.invalidNumber;
                      if (n < 0) return l10n.negativeNotAllowed;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _weightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.weightKg,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final n =
                          double.tryParse(v.trim().replaceAll(',', '.'));
                      if (n == null) return l10n.invalidNumber;
                      if (n < 0) return l10n.negativeNotAllowed;
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submit,
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// Add-set bottom sheet (reps + weight)
// ──────────────────────────────────────────────────

class _SetEditorSheet extends StatefulWidget {
  const _SetEditorSheet();

  @override
  State<_SetEditorSheet> createState() => _SetEditorSheetState();
}

class _SetEditorSheetState extends State<_SetEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  final _repsCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  @override
  void dispose() {
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      ExerciseSet(
        reps: int.tryParse(_repsCtrl.text.trim()) ?? 0,
        weightKg:
            double.tryParse(_weightCtrl.text.trim().replaceAll(',', '.')) ??
                0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.addSet,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _repsCtrl,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.reps,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.cannotBeEmpty;
                      }
                      final n = int.tryParse(v.trim());
                      if (n == null) return l10n.invalidNumber;
                      if (n < 0) return l10n.negativeNotAllowed;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _weightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.weightKg,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final n =
                          double.tryParse(v.trim().replaceAll(',', '.'));
                      if (n == null) return l10n.invalidNumber;
                      if (n < 0) return l10n.negativeNotAllowed;
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submit,
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }
}
