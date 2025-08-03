import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrayerFilterTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final Map<String, int> tabCounts;

  const PrayerFilterTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.tabCounts = const {},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final tabName = tabs[index];
          final count = tabCounts[tabName] ?? 0;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onTabSelected(index);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(right: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          offset: Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTabIcon(tabName, isSelected, colorScheme),
                  if (_shouldShowIcon(tabName)) SizedBox(width: 2.w),
                  Text(
                    tabName,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected ? Colors.white : colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (count > 0) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabIcon(
      String tabName, bool isSelected, ColorScheme colorScheme) {
    if (!_shouldShowIcon(tabName)) return SizedBox.shrink();

    String iconName;
    switch (tabName.toLowerCase()) {
      case 'all':
        iconName = 'list';
        break;
      case 'my requests':
        iconName = 'person';
        break;
      case 'praying for':
        iconName = 'favorite';
        break;
      case 'answered':
        iconName = 'check_circle';
        break;
      default:
        iconName = 'list';
    }

    return CustomIconWidget(
      iconName: iconName,
      color: isSelected
          ? Colors.white
          : colorScheme.onSurface.withValues(alpha: 0.7),
      size: 16,
    );
  }

  bool _shouldShowIcon(String tabName) {
    return ['All', 'My Requests', 'Praying For', 'Answered'].contains(tabName);
  }
}
