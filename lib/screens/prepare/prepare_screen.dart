import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/checklist_progress_store.dart';
import '../../data/mock/checklist_data.dart';
import '../../models/checklist_item.dart';
import '../../models/trek_plan.dart';
import '../../widgets/checklist_item_tile.dart';
import '../../widgets/section_header.dart';

/// Screen displaying preparation checklist, progress percentage, and readiness status.
class PrepareScreen extends StatelessWidget {
  const PrepareScreen({super.key, required this.plan});

  final TrekPlan plan;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final trek = plan.trek;
    final categories = checklistFor(trek.id);

    final formattedDistance =
        '${trek.distanceKm.toStringAsFixed(trek.distanceKm.truncateToDouble() == trek.distanceKm ? 0 : 1)} km';
    final trekMetaLine =
        '${trek.difficulty.label} • $formattedDistance • ${trek.duration}';

    // Total items across all categories
    final totalItems = categories.fold<int>(
      0,
      (count, cat) => count + cat.items.length,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preparation'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: ValueListenableBuilder<Map<String, Set<String>>>(
        valueListenable: checklistProgress,
        builder: (context, progressMap, _) {
          final completed = completedIdsFor(trek.id);
          final completedCount = completed.length;
          final percent = totalItems == 0
              ? 0
              : (completedCount / totalItems * 100).round();
          final status = ReadinessStatus.fromPercent(percent);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Section
                Text(
                  'Prepare for ${trek.name}',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trekMetaLine,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // 2. Progress Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Your Preparation',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),
                          _StatusPill(status: status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '$percent%',
                        style: textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        status.message,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: LinearProgressIndicator(
                          value: percent / 100.0,
                          minHeight: 8,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Based on checklist completion only.',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                          fontSize: AppTextSize.xs,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // 3. Category Sections
                for (final category in categories) ...[
                  SectionHeader(title: category.name),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (int i = 0; i < category.items.length; i++) ...[
                          if (i > 0)
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.border,
                            ),
                          ChecklistItemTile(
                            item: category.items[i],
                            checked: completed.contains(category.items[i].id),
                            onChanged: (_) {
                              toggleChecklistItem(trek.id, category.items[i].id);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final ReadinessStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      ReadinessStatus.ready => (
          AppColors.primaryGreen.withValues(alpha: 0.12),
          AppColors.primaryGreen,
        ),
      ReadinessStatus.almostReady => (
          AppColors.accentOrange.withValues(alpha: 0.15),
          const Color(0xFFC75D0A),
        ),
      ReadinessStatus.gettingReady => (
          AppColors.accentOrange.withValues(alpha: 0.15),
          const Color(0xFFC75D0A),
        ),
      ReadinessStatus.notReady => (
          AppColors.border,
          AppColors.secondaryText,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: fg,
          fontSize: AppTextSize.xs,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

