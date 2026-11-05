import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/date_format.dart';
import '../data/plan_store.dart';
import '../models/trek_plan.dart';

/// Card displaying details of a planned or completed trek in the History tab.
class HistoryPlanCard extends StatelessWidget {
  const HistoryPlanCard({
    super.key,
    required this.plan,
  });

  final TrekPlan plan;

  IconData _transportIcon(Transport transport) {
    return switch (transport) {
      Transport.car => Icons.directions_car_outlined,
      Transport.bus => Icons.directions_bus_outlined,
      Transport.train => Icons.train_outlined,
      Transport.bike => Icons.two_wheeler_outlined,
    };
  }

  void _showCompleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Mark ${plan.trek.name} as completed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                markPlanCompleted(plan);
                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.surface,
              ),
              child: const Text('Mark Completed'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final trek = plan.trek;
    final isCompleted = plan.status == PlanStatus.completed;

    final distanceStr =
        '${trek.distanceKm.toStringAsFixed(trek.distanceKm.truncateToDouble() == trek.distanceKm ? 0 : 1)} km';
    final difficultyDistance = '${trek.difficulty.label} • $distanceStr';
    final startingFrom = 'From ${plan.startingPoint}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Trek name + Status pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
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
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Status Pill
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 14,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Completed',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: AppTextSize.xs,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'Planned',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.accentOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: AppTextSize.xs,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.md),

          // Date & Meta
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: AppColors.secondaryText,
              ),
              const SizedBox(width: 6),
              Text(
                formatTrekDate(plan.date),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  difficultyDistance,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Starting point & Transport
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                size: 15,
                color: AppColors.secondaryText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  startingFrom,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                _transportIcon(plan.transport),
                size: 15,
                color: AppColors.secondaryText,
              ),
              const SizedBox(width: 4),
              Text(
                plan.transport.label,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Planned action: Mark as Completed
          if (!isCompleted) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showCompleteDialog(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                child: const Text('Mark as Completed'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

