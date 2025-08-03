import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final quickActions = [
      {
        'title': 'Give & Tithe',
        'icon': 'volunteer_activism',
        'color': theme.colorScheme.secondary,
        'route': '/give-and-tithe-screen',
        'description': 'Support the ministry',
      },
      {
        'title': 'Prayer Requests',
        'icon': 'favorite',
        'color': theme.colorScheme.primary,
        'route': '/prayer-requests-screen',
        'description': 'Submit prayer needs',
      },
      {
        'title': 'Events',
        'icon': 'event',
        'color': theme.colorScheme.tertiary,
        'route': '/church-events-screen',
        'description': 'Upcoming activities',
      },
      {
        'title': 'Members',
        'icon': 'people',
        'color': theme.colorScheme.primary.withValues(alpha: 0.8),
        'route': '/member-directory-screen',
        'description': 'Church directory',
      },
    ];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.1,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return _buildActionCard(context, action, theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    Map<String, dynamic> action,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, action['route'] as String);
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomIconWidget(
                  iconName: action['icon'] as String,
                  color: action['color'] as Color,
                  size: 32,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                action['title'] as String,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                action['description'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
