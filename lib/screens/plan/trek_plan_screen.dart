import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_format.dart';
import '../../data/plan_store.dart';
import '../../models/trek.dart';
import '../../models/trek_plan.dart';
import '../../widgets/trek_card.dart';

/// Screen allowing the user to configure and save a trek plan.
class TrekPlanScreen extends StatefulWidget {
  const TrekPlanScreen({super.key, required this.trek});

  final Trek trek;

  @override
  State<TrekPlanScreen> createState() => _TrekPlanScreenState();
}

class _TrekPlanScreenState extends State<TrekPlanScreen> {
  DateTime? _selectedDate;
  String? _selectedStartingPoint;
  Transport? _selectedTransport;

  static const List<String> _startingPoints = <String>[
    'Mumbai',
    'Navi Mumbai',
    'Thane',
    'Pune',
    'Other',
  ];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = today.add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primaryGreen,
                  onPrimary: AppColors.surface,
                  surface: AppColors.surface,
                  onSurface: AppColors.primaryText,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _savePlan() {
    // 1. Validation in exact specified order
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a trek date.')),
      );
      return;
    }

    if (_selectedStartingPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a starting point.')),
      );
      return;
    }

    if (_selectedTransport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mode of transport.')),
      );
      return;
    }

    // 2. Save in-memory
    final newPlan = TrekPlan(
      trek: widget.trek,
      date: _selectedDate!,
      startingPoint: _selectedStartingPoint!,
      transport: _selectedTransport!,
    );

    final saved = savePlan(newPlan);
    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You've already planned this trek for that date."),
        ),
      );
      return;
    }

    // 3. Feedback and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trek plan saved')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final trek = widget.trek;
    final formattedDistance =
        '${trek.distanceKm.toStringAsFixed(trek.distanceKm.truncateToDouble() == trek.distanceKm ? 0 : 1)} km';
    final trekMetaLine =
        '${trek.difficulty.label} • $formattedDistance • ${trek.duration}';

    final hasAllSelections =
        _selectedDate != null && _selectedStartingPoint != null && _selectedTransport != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Trek'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              110, // Generous padding so content never gets covered by pinned button
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Selected Trek Section
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trek banner image placeholder
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFE4ECD3), Color(0xFFC7DAB0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.terrain_rounded,
                                size: 48,
                                color: AppColors.primaryGreen.withValues(alpha: 0.35),
                              ),
                            ),
                            Positioned(
                              top: AppSpacing.md,
                              left: AppSpacing.md,
                              child: DifficultyBadge(difficulty: trek.difficulty.label),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trek.name,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 15,
                                  color: AppColors.secondaryText,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    trek.location,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.secondaryText,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              trekMetaLine,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // 2. Trek Date Section
                Text(
                  'Trek Date',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: _selectedDate != null
                              ? AppColors.primaryGreen
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                            color: _selectedDate != null
                                ? AppColors.primaryGreen
                                : AppColors.secondaryText,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              _selectedDate != null
                                  ? formatTrekDate(_selectedDate!)
                                  : 'Select Date',
                              style: TextStyle(
                                fontSize: AppTextSize.md,
                                fontWeight: _selectedDate != null
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: _selectedDate != null
                                    ? AppColors.primaryText
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: AppColors.secondaryText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // 3. Starting Point Section
                Text(
                  'Starting Point',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: _startingPoints.map((city) {
                    final isSelected = _selectedStartingPoint == city;
                    return ChoiceChip(
                      label: Text(city),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStartingPoint = selected ? city : null;
                        });
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.surface : AppColors.primaryText,
                        fontSize: AppTextSize.sm,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      selectedColor: AppColors.primaryGreen,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryGreen : AppColors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // 4. How are you travelling? Section
                Text(
                  'How are you travelling?',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: _TransportCard(
                        icon: Icons.directions_car_outlined,
                        label: 'Car',
                        isSelected: _selectedTransport == Transport.car,
                        onTap: () {
                          setState(() {
                            _selectedTransport =
                                _selectedTransport == Transport.car ? null : Transport.car;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: _TransportCard(
                        icon: Icons.directions_bus_outlined,
                        label: 'Bus',
                        isSelected: _selectedTransport == Transport.bus,
                        onTap: () {
                          setState(() {
                            _selectedTransport =
                                _selectedTransport == Transport.bus ? null : Transport.bus;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: _TransportCard(
                        icon: Icons.train_outlined,
                        label: 'Train',
                        isSelected: _selectedTransport == Transport.train,
                        onTap: () {
                          setState(() {
                            _selectedTransport =
                                _selectedTransport == Transport.train ? null : Transport.train;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: _TransportCard(
                        icon: Icons.two_wheeler_outlined,
                        label: 'Bike',
                        isSelected: _selectedTransport == Transport.bike,
                        onTap: () {
                          setState(() {
                            _selectedTransport =
                                _selectedTransport == Transport.bike ? null : Transport.bike;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // 5. Your Trek Plan (Summary card, only when all 3 selections made)
                if (hasAllSelections) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Your Trek Plan',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: AppColors.primaryGreen.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 20,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                trek.name,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: AppSpacing.xl, color: AppColors.border),
                        _SummaryRow(
                          label: 'Date',
                          value: formatTrekDate(_selectedDate!),
                          icon: Icons.calendar_today_outlined,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _SummaryRow(
                          label: 'Starting from',
                          value: _selectedStartingPoint!,
                          icon: Icons.place_outlined,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _SummaryRow(
                          label: 'Transport',
                          value: _selectedTransport!.label,
                          icon: switch (_selectedTransport!) {
                            Transport.car => Icons.directions_car_outlined,
                            Transport.bus => Icons.directions_bus_outlined,
                            Transport.train => Icons.train_outlined,
                            Transport.bike => Icons.two_wheeler_outlined,
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _SummaryRow(
                          label: 'Distance',
                          value: formattedDistance,
                          icon: Icons.straighten_rounded,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _SummaryRow(
                          label: 'Duration',
                          value: trek.duration,
                          icon: Icons.schedule_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 6. Save Trek Plan pinned to bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: const Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: FilledButton(
                  onPressed: _savePlan,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.surface,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  child: const Text(
                    'Save Trek Plan',
                    style: TextStyle(
                      fontSize: AppTextSize.md,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransportCard extends StatelessWidget {
  const _TransportCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.primaryGreen
          : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.border,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? AppColors.surface : AppColors.primaryText,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppTextSize.xs,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.surface : AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondaryText),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTextSize.sm,
            color: AppColors.secondaryText,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppTextSize.sm,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}

