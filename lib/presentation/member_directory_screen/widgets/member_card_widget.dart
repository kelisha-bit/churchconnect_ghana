import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class MemberCardWidget extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const MemberCardWidget({
    super.key,
    required this.member,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isFavorite = member['isFavorite'] ?? false;
    final bool isNewMember = member['isNewMember'] ?? false;
    final bool showPhone = member['showPhone'] ?? true;
    final bool showEmail = member['showEmail'] ?? true;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              // Profile Image
              Stack(
                children: [
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: member['profileImage'] ?? '',
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isNewMember)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: AppTheme.successLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 1,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'fiber_new',
                          color: Colors.white,
                          size: 2.w,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 3.w),

              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member['name'] ?? 'Unknown Member',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isFavorite)
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.warningLight,
                            size: 4.w,
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    if (member['role'] != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          member['role'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                    ],
                    if (member['ministry'] != null)
                      Text(
                        member['ministry'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (member['location'] != null)
                      Text(
                        member['location'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  if (showPhone && member['phone'] != null)
                    _buildActionButton(
                      context,
                      'phone',
                      () => _makePhoneCall(member['phone']),
                      colorScheme.primary,
                    ),
                  SizedBox(height: 1.h),
                  if (showPhone && member['phone'] != null)
                    _buildActionButton(
                      context,
                      'message',
                      () => _sendWhatsApp(member['phone']),
                      Colors.green,
                    ),
                  SizedBox(height: 1.h),
                  if (showEmail && member['email'] != null)
                    _buildActionButton(
                      context,
                      'email',
                      () => _sendEmail(member['email']),
                      colorScheme.secondary,
                    ),
                ],
              ),

              SizedBox(width: 2.w),

              // Favorite Toggle
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onFavoriteToggle?.call();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: isFavorite ? 'star' : 'star_border',
                    color: isFavorite
                        ? AppTheme.warningLight
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String iconName,
    VoidCallback onPressed,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 4.w,
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendWhatsApp(String phoneNumber) async {
    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanNumber');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}
