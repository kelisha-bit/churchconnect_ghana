import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class MinistryFilterWidget extends StatelessWidget {
  final List<String> ministries;
  final String? selectedMinistry;
  final ValueChanged<String?> onMinistrySelected;

  const MinistryFilterWidget({
    super.key,
    required this.ministries,
    this.selectedMinistry,
    required this.onMinistrySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: ministries.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildFilterChip(
              context,
              'All',
              selectedMinistry == null,
              () {
                HapticFeedback.lightImpact();
                onMinistrySelected(null);
              },
              colorScheme,
              theme,
            );
          }

          final ministry = ministries[index - 1];
          final isSelected = selectedMinistry == ministry;

          return _buildFilterChip(
            context,
            ministry,
            isSelected,
            () {
              HapticFeedback.lightImpact();
              onMinistrySelected(ministry);
            },
            colorScheme,
            theme,
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.5.h,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      offset: Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
