import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PurposeDropdown extends StatelessWidget {
  final String selectedPurpose;
  final Function(String) onPurposeChanged;
  final TextEditingController customPurposeController;

  const PurposeDropdown({
    super.key,
    required this.selectedPurpose,
    required this.onPurposeChanged,
    required this.customPurposeController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final purposes = [
      {'id': 'tithe', 'name': 'General Tithe', 'icon': 'volunteer_activism'},
      {'id': 'offering', 'name': 'Sunday Offering', 'icon': 'church'},
      {'id': 'building', 'name': 'Building Fund', 'icon': 'home_work'},
      {'id': 'missions', 'name': 'Missions', 'icon': 'public'},
      {'id': 'youth', 'name': 'Youth Ministry', 'icon': 'groups'},
      {'id': 'custom', 'name': 'Other (Specify)', 'icon': 'edit'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'category',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Purpose of Giving',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Purpose Options
          Column(
            children: purposes.map((purpose) {
              final isSelected = selectedPurpose == purpose['id'];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onPurposeChanged(purpose['id'] as String);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: purpose['icon'] as String,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          purpose['name'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: colorScheme.primary,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Custom Purpose Input
          if (selectedPurpose == 'custom') ...[
            SizedBox(height: 1.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: customPurposeController,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Please specify the purpose...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(4.w),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'edit',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                maxLines: 2,
                maxLength: 100,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
