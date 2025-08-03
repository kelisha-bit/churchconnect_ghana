import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrayerRequestCard extends StatefulWidget {
  final Map<String, dynamic> request;
  final VoidCallback? onTap;
  final VoidCallback? onPrayTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const PrayerRequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.onPrayTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  State<PrayerRequestCard> createState() => _PrayerRequestCardState();
}

class _PrayerRequestCardState extends State<PrayerRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _animationController.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _animationController.reverse();
              if (widget.onTap != null) {
                HapticFeedback.lightImpact();
                widget.onTap!();
              }
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            onLongPress: widget.showActions
                ? () {
                    HapticFeedback.mediumImpact();
                    _showActionSheet(context);
                  }
                : null,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: 1.5.h),
                    _buildContent(context),
                    SizedBox(height: 2.h),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAnonymous = widget.request['isAnonymous'] as bool? ?? false;
    final memberName = widget.request['memberName'] as String? ?? 'Anonymous';
    final privacyLevel = widget.request['privacyLevel'] as String? ?? 'Public';

    return Row(
      children: [
        // Member Avatar/Initials
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: isAnonymous
                ? colorScheme.outline.withValues(alpha: 0.2)
                : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Center(
            child: Text(
              isAnonymous
                  ? '?'
                  : memberName.split(' ').map((e) => e[0]).take(2).join(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isAnonymous
                    ? colorScheme.onSurface.withValues(alpha: 0.6)
                    : AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),

        // Member Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAnonymous ? 'Anonymous Request' : memberName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  _buildPrivacyIcon(privacyLevel, colorScheme),
                  SizedBox(width: 1.w),
                  Text(
                    _getTimeAgo(widget.request['timestamp']),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Category Tag
        _buildCategoryTag(context),
      ],
    );
  }

  Widget _buildPrivacyIcon(String privacyLevel, ColorScheme colorScheme) {
    IconData iconData;
    Color iconColor;

    switch (privacyLevel.toLowerCase()) {
      case 'public':
        iconData = Icons.public;
        iconColor = colorScheme.primary;
        break;
      case 'small group only':
        iconData = Icons.group;
        iconColor = colorScheme.secondary;
        break;
      case 'pastoral team only':
        iconData = Icons.admin_panel_settings;
        iconColor = colorScheme.tertiary;
        break;
      default:
        iconData = Icons.lock_outline;
        iconColor = colorScheme.onSurface.withValues(alpha: 0.6);
    }

    return CustomIconWidget(
      iconName: iconData.codePoint.toString(),
      color: iconColor,
      size: 16,
    );
  }

  Widget _buildCategoryTag(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final category = widget.request['category'] as String? ?? 'General';

    Color tagColor;
    switch (category.toLowerCase()) {
      case 'health':
        tagColor = Colors.red.withValues(alpha: 0.1);
        break;
      case 'family':
        tagColor = Colors.blue.withValues(alpha: 0.1);
        break;
      case 'work':
        tagColor = Colors.orange.withValues(alpha: 0.1);
        break;
      case 'spiritual':
        tagColor = Colors.purple.withValues(alpha: 0.1);
        break;
      default:
        tagColor = colorScheme.primary.withValues(alpha: 0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final title = widget.request['title'] as String? ?? '';
    final description = widget.request['description'] as String? ?? '';
    final excerpt = description.length > 100
        ? '${description.substring(0, 100)}...'
        : description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
        ],
        Text(
          excerpt,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.8),
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final prayerCount = widget.request['prayerCount'] as int? ?? 0;
    final isAnswered = widget.request['isAnswered'] as bool? ?? false;

    return Row(
      children: [
        // Prayer Button
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.onPrayTap != null) {
                HapticFeedback.lightImpact();
                widget.onPrayTap!();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'favorite',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Pray',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 3.w),

        // Prayer Count
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: Colors.red.withValues(alpha: 0.7),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                prayerCount.toString(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Answered Badge
        if (isAnswered) ...[
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.green,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Answered',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                title: Text('Edit Request'),
                onTap: () {
                  Navigator.pop(context);
                  if (widget.onEdit != null) {
                    widget.onEdit!();
                  }
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: Colors.red,
                  size: 24,
                ),
                title: Text('Delete Request'),
                onTap: () {
                  Navigator.pop(context);
                  if (widget.onDelete != null) {
                    widget.onDelete!();
                  }
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Just now';

    DateTime dateTime;
    if (timestamp is DateTime) {
      dateTime = timestamp;
    } else if (timestamp is String) {
      dateTime = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      return 'Just now';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
