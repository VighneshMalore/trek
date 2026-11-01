import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../models/checklist_item.dart';

/// A checklist item row with an integrated checkbox and tap target.
class ChecklistItemTile extends StatelessWidget {
  const ChecklistItemTile({
    super.key,
    required this.item,
    required this.checked,
    required this.onChanged,
  });

  final ChecklistItem item;
  final bool checked;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final titleColor = checked
        ? AppColors.secondaryText
        : AppColors.primaryText;
    final descriptionColor = checked
        ? AppColors.secondaryText.withValues(alpha: 0.7)
        : AppColors.secondaryText;

    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!checked) : null,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: checked,
              onChanged: onChanged,
              activeColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: AppTextSize.md,
                      fontWeight: checked ? FontWeight.w400 : FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.description!,
                      style: TextStyle(
                        fontSize: AppTextSize.xs,
                        color: descriptionColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

