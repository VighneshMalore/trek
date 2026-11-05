import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/safety_data.dart';
import '../../models/trek.dart';
import '../../widgets/checklist_item_tile.dart';

/// Screen displaying emergency numbers, safety tips, warnings, and local checklist.
class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key, this.trek});

  final Trek? trek;

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  // In-memory checked checklist item IDs (no persistence required).
  final Set<String> _checkedIds = <String>{};

  Future<void> _handleCall(BuildContext context, EmergencyContact contact) async {
    try {
      final uri = Uri(scheme: 'tel', path: contact.number);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't open the dialer.")),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the dialer.")),
      );
    }
  }

  void _toggleChecklistItem(String id, bool? checked) {
    setState(() {
      if (checked == true) {
        _checkedIds.add(id);
      } else {
        _checkedIds.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            _buildHeader(textTheme),
            const SizedBox(height: AppSpacing.xxl),

            // 2. Emergency Contacts
            _buildSectionTitle(textTheme, 'Emergency Contacts'),
            const SizedBox(height: AppSpacing.sm),
            ...emergencyContacts.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _EmergencyContactCard(
                  contact: c,
                  onCall: () => _handleCall(context, c),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 3. Trek Safety Tips
            _buildSectionTitle(textTheme, 'Trek Safety Tips'),
            const SizedBox(height: AppSpacing.sm),
            ...safetyTipGroups.map(
              (group) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _SafetyTipGroupCard(group: group),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 4. Important Warnings
            _buildSectionTitle(textTheme, 'Important Warnings'),
            const SizedBox(height: AppSpacing.sm),
            const _ImportantWarningsCard(),
            const SizedBox(height: AppSpacing.xxl),

            // 5. Checklist ("Before starting")
            _buildSectionTitle(textTheme, 'Before starting'),
            const SizedBox(height: AppSpacing.sm),
            _buildChecklistCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety',
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Stay prepared. Stay safe.',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        if (widget.trek != null) ...[
          const SizedBox(height: 4),
          Text(
            'For ${widget.trek!.name}',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(TextTheme textTheme, String title) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildChecklistCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        children: safetyChecklistItems.map((item) {
          final isChecked = _checkedIds.contains(item.id);
          return ChecklistItemTile(
            item: item,
            checked: isChecked,
            onChanged: (val) => _toggleChecklistItem(item.id, val),
          );
        }).toList(),
      ),
    );
  }
}

/// Compact white card displaying an emergency contact row.
class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({
    required this.contact,
    required this.onCall,
  });

  final EmergencyContact contact;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: contact.isPrimary
                  ? AppColors.primaryGreen.withValues(alpha: 0.12)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              contact.icon,
              size: 22,
              color: contact.isPrimary
                  ? AppColors.primaryGreen
                  : AppColors.secondaryText,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.service,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  contact.number,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: contact.isPrimary
                        ? AppColors.primaryGreen
                        : AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            label: 'Call ${contact.service} ${contact.number}',
            button: true,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
              child: contact.isPrimary
                  ? FilledButton(
                      onPressed: onCall,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                      child: const Text('Call'),
                    )
                  : OutlinedButton(
                      onPressed: onCall,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        side: const BorderSide(color: AppColors.primaryGreen),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                      child: const Text('Call'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact card containing a grouped set of safety tips with short bullet rows.
class _SafetyTipGroupCard extends StatelessWidget {
  const _SafetyTipGroupCard({required this.group});

  final SafetyTipGroup group;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ...group.tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•  ',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondaryText,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Orange-accent-tinted card with warning rows and dark text for contrast.
class _ImportantWarningsCard extends StatelessWidget {
  const _ImportantWarningsCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8D4),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.accentOrange.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: importantWarnings.map((warning) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: AppColors.accentOrange,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    warning,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

