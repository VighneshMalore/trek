import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/plan_store.dart';
import '../../models/trek_plan.dart';
import '../../widgets/history_plan_card.dart';

/// Screen displaying planned and completed treks.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.onExploreTreks});

  final VoidCallback? onExploreTreks;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  PlanStatus _selectedStatus = PlanStatus.planned;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ValueListenableBuilder<List<TrekPlan>>(
          valueListenable: savedPlans,
          builder: (context, plans, _) {
            // Sort Planned: soonest first
            final plannedPlans = plans
                .where((p) => p.status == PlanStatus.planned)
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));

            // Sort Completed: most recent first
            final completedPlans = plans
                .where((p) => p.status == PlanStatus.completed)
                .toList()
              ..sort((a, b) => b.date.compareTo(a.date));

            final currentList = _selectedStatus == PlanStatus.planned
                ? plannedPlans
                : completedPlans;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xxxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header
                  Text(
                    'History',
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your trekking journey',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 2. Filter: SegmentedButton
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<PlanStatus>(
                      segments: const <ButtonSegment<PlanStatus>>[
                        ButtonSegment<PlanStatus>(
                          value: PlanStatus.planned,
                          label: Text('Planned'),
                        ),
                        ButtonSegment<PlanStatus>(
                          value: PlanStatus.completed,
                          label: Text('Completed'),
                        ),
                      ],
                      selected: <PlanStatus>{_selectedStatus},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedStatus = newSelection.first;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.primaryGreen
                                .withValues(alpha: 0.12);
                          }
                          return AppColors.surface;
                        }),
                        foregroundColor:
                            WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.primaryGreen;
                          }
                          return AppColors.primaryText;
                        }),
                        side: const WidgetStatePropertyAll(
                          BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 3. List or Empty state
                  if (currentList.isEmpty)
                    _buildEmptyState(plans, textTheme)
                  else
                    ...currentList.map(
                      (plan) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: HistoryPlanCard(plan: plan),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(List<TrekPlan> allPlans, TextTheme textTheme) {
    final String title;
    final String subtitle;
    final bool showExploreButton;

    if (_selectedStatus == PlanStatus.planned) {
      if (allPlans.isEmpty) {
        title = 'No treks yet';
        subtitle = 'Plan your first trek and it will appear here.';
      } else {
        title = 'No planned treks';
        subtitle = 'Plan your next trek and it will appear here.';
      }
      showExploreButton = true;
    } else {
      title = 'No completed treks yet';
      subtitle = 'Complete a planned trek and your journey will appear here.';
      showExploreButton = false;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxxl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.hiking_rounded,
                size: 32,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            if (showExploreButton) ...[
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: widget.onExploreTreks,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                child: const Text('Explore Treks'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
