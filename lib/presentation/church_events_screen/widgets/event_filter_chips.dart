import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class EventFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const EventFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Services', 'Youth', 'Outreach', 'Meetings'];

    return Container(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return FilterChip(
            label: Text(
              filter,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                HapticFeedback.lightImpact();
                onFilterChanged(filter);
              }
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            selectedColor: AppTheme.lightTheme.colorScheme.primary,
            checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
            side: BorderSide(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          );
        },
      ),
    );
  }
}
