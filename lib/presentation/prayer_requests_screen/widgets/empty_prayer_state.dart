import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyPrayerState extends StatelessWidget {
  final String filterType;
  final VoidCallback? onCreateRequest;

  const EmptyPrayerState({
    super.key,
    required this.filterType,
    this.onCreateRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(context),
            SizedBox(height: 4.h),
            _buildTitle(context),
            SizedBox(height: 2.h),
            _buildDescription(context),
            SizedBox(height: 3.h),
            _buildScriptureVerse(context),
            if (onCreateRequest != null && _shouldShowCreateButton()) ...[
              SizedBox(height: 4.h),
              _buildCreateButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15.w),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: _getIconName(),
          color: AppTheme.lightTheme.primaryColor,
          size: 15.w,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      _getTitle(),
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      _getDescription(),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildScriptureVerse(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'format_quote',
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
          SizedBox(height: 2.h),
          Text(
            _getScriptureVerse(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            _getScriptureReference(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onCreateRequest,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Share Prayer Request',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIconName() {
    switch (filterType.toLowerCase()) {
      case 'my requests':
        return 'person_outline';
      case 'praying for':
        return 'favorite_outline';
      case 'answered':
        return 'celebration';
      default:
        return 'volunteer_activism';
    }
  }

  String _getTitle() {
    switch (filterType.toLowerCase()) {
      case 'my requests':
        return 'No Prayer Requests Yet';
      case 'praying for':
        return 'No Prayers Offered Yet';
      case 'answered':
        return 'No Answered Prayers Yet';
      default:
        return 'No Prayer Requests';
    }
  }

  String _getDescription() {
    switch (filterType.toLowerCase()) {
      case 'my requests':
        return 'You haven\'t shared any prayer requests with the church family yet. When you do, they\'ll appear here.';
      case 'praying for':
        return 'You haven\'t prayed for any requests yet. Tap the pray button on any request to show your support.';
      case 'answered':
        return 'No prayers have been marked as answered yet. When God answers prayers, they\'ll be celebrated here.';
      default:
        return 'The church family hasn\'t shared any prayer requests yet. Be the first to share and encourage others to join in prayer.';
    }
  }

  String _getScriptureVerse() {
    switch (filterType.toLowerCase()) {
      case 'my requests':
        return 'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.';
      case 'praying for':
        return 'Therefore confess your sins to each other and pray for each other so that you may be healed. The prayer of a righteous person is powerful and effective.';
      case 'answered':
        return 'This is the confidence we have in approaching God: that if we ask anything according to his will, he hears us.';
      default:
        return 'Again, truly I tell you that if two of you on earth agree about anything they ask for, it will be done for them by my Father in heaven.';
    }
  }

  String _getScriptureReference() {
    switch (filterType.toLowerCase()) {
      case 'my requests':
        return 'Philippians 4:6';
      case 'praying for':
        return 'James 5:16';
      case 'answered':
        return '1 John 5:14';
      default:
        return 'Matthew 18:19';
    }
  }

  bool _shouldShowCreateButton() {
    return ['all', 'my requests'].contains(filterType.toLowerCase());
  }
}
