import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  bool _goalsSaved = false;
  bool _weightSaved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final goals = context.read<NutritionProvider>().defaultGoals;
    _caloriesCtrl.text = goals.calories.toStringAsFixed(0);
    _proteinCtrl.text = goals.protein.toStringAsFixed(0);
    _carbsCtrl.text = goals.carbs.toStringAsFixed(0);
    _fatCtrl.text = goals.fat.toStringAsFixed(0);

    final weights = context.read<NutritionProvider>().weightLogs;
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

  Future<void> _saveWeight() async {
    final text = _weightCtrl.text.trim();
    final value = double.tryParse(text);
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir kilo değeri girin')),
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Ayarlar'),
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
                      title: 'Günlük Hedefler',
                    ),
                    const SizedBox(height: 12),
                    _buildGoalField(
                      _caloriesCtrl,
                      'Kalori Hedefi (kcal)',
                      Icons.local_fire_department_outlined,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGoalField(
                            _proteinCtrl,
                            'Protein (g)',
                            null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGoalField(
                            _carbsCtrl,
                            'Karbonhidrat (g)',
                            null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGoalField(
                            _fatCtrl,
                            'Yağ (g)',
                            null,
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
                      label: Text(_goalsSaved ? 'Kaydedildi!' : 'Hedefleri Kaydet'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _SectionHeader(
                      icon: Icons.monitor_weight_outlined,
                      title: 'Mevcut Kilo',
                    ),
                    const SizedBox(height: 12),
                    _WeightCard(
                      controller: _weightCtrl,
                      onSave: _saveWeight,
                      saved: _weightSaved,
                      provider: context.watch<NutritionProvider>(),
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
        if (v == null || v.trim().isEmpty) return 'Boş bırakılamaz';
        final n = double.tryParse(v.trim());
        if (n == null || n < 0) return 'Geçersiz değer';
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
                  _StatItem(label: 'Başlangıç', value: firstWeight),
                  _StatItem(label: 'Güncel', value: lastWeight),
                  if (diff != null)
                    _StatItem(
                      label: 'Değişim',
                      value:
                          '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg',
                      valueColor: diff <= 0
                          ? Colors.greenAccent
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
                decoration: const InputDecoration(
                  labelText: 'Bugünkü Kilo (kg)',
                  prefixIcon: Icon(Icons.scale_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: onSave,
              icon: Icon(saved ? Icons.check : Icons.save_outlined),
              label: Text(saved ? 'Kaydedildi!' : 'Kaydet'),
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
