import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyEventsState extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool showCreateEventButton;

  const EmptyEventsState({
    super.key,
    required this.message,
    this.actionText,
    this.onActionPressed,
    this.showCreateEventButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Icon
            Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'event_note',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 12.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Empty State Title
            Text(
              'No Events Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Empty State Message
            Text(
              message,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action Buttons
            if (showCreateEventButton) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (onActionPressed != null) {
                      onActionPressed!();
                    }
                  },
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text('Create Event'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Secondary Action
            if (actionText != null && onActionPressed != null)
              TextButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onActionPressed!();
                },
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18,
                ),
                label: Text(actionText!),
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                ),
              ),

            SizedBox(height: 4.h),

            // Suggestions
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get Involved in Church Activities:',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildSuggestionItem(
                    'Join our Sunday worship services',
                    'church',
                  ),
                  _buildSuggestionItem(
                    'Participate in youth fellowship',
                    'groups',
                  ),
                  _buildSuggestionItem(
                    'Volunteer for community outreach',
                    'volunteer_activism',
                  ),
                  _buildSuggestionItem(
                    'Attend Bible study sessions',
                    'menu_book',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String text, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
