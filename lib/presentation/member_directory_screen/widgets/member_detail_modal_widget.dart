import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class MemberDetailModalWidget extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback? onClose;
  final VoidCallback? onFavoriteToggle;

  const MemberDetailModalWidget({
    super.key,
    required this.member,
    this.onClose,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Member Details',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 2.h,
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  _buildProfileSection(context, colorScheme, theme),

                  SizedBox(height: 3.h),

                  // Contact Actions
                  _buildContactActions(context, colorScheme, theme),

                  SizedBox(height: 3.h),

                  // Bio Section
                  if (member['bio'] != null)
                    _buildBioSection(context, colorScheme, theme),

                  SizedBox(height: 3.h),

                  // Ministry Information
                  _buildMinistrySection(context, colorScheme, theme),

                  SizedBox(height: 3.h),

                  // Family Connections
                  if (member['family'] != null)
                    _buildFamilySection(context, colorScheme, theme),

                  SizedBox(height: 3.h),

                  // Small Groups
                  if (member['smallGroups'] != null)
                    _buildSmallGroupsSection(context, colorScheme, theme),

                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
      BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    final bool isFavorite = member['isFavorite'] ?? false;
    final bool isNewMember = member['isNewMember'] ?? false;

    return Row(
      children: [
        // Profile Image
        Stack(
          children: [
            Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: member['profileImage'] ?? '',
                  width: 25.w,
                  height: 25.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isNewMember)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.successLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'NEW',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 8.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(width: 4.w),

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
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                        size: 6.w,
                      ),
                    ),
                  ),
                ],
              ),
              if (member['role'] != null) ...[
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    member['role'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              if (member['joinDate'] != null) ...[
                SizedBox(height: 1.h),
                Text(
                  'Member since ${member['joinDate']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactActions(
      BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    final bool showPhone = member['showPhone'] ?? true;
    final bool showEmail = member['showEmail'] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            if (showPhone && member['phone'] != null) ...[
              Expanded(
                child: _buildActionButton(
                  context,
                  'Call',
                  'phone',
                  () => _makePhoneCall(member['phone']),
                  colorScheme.primary,
                  theme,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildActionButton(
                  context,
                  'WhatsApp',
                  'message',
                  () => _sendWhatsApp(member['phone']),
                  Colors.green,
                  theme,
                ),
              ),
              if (showEmail && member['email'] != null) SizedBox(width: 2.w),
            ],
            if (showEmail && member['email'] != null)
              Expanded(
                child: _buildActionButton(
                  context,
                  'Email',
                  'email',
                  () => _sendEmail(member['email']),
                  colorScheme.secondary,
                  theme,
                ),
              ),
          ],
        ),
        if (showPhone && member['phone'] != null) ...[
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'phone',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                member['phone'],
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
        if (showEmail && member['email'] != null) ...[
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'email',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  member['email'],
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onPressed,
    Color color,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioSection(
      BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          member['bio'],
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMinistrySection(
      BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ministry Involvement',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        if (member['ministry'] != null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['ministry'],
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (member['ministryRole'] != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    member['ministryRole'],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFamilySection(
      BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    final List<dynamic> family = member['family'] as List<dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...family.map((familyMember) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: colorScheme.primary,
                      size: 5.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        familyMember['name'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        familyMember['relationship'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSmallGroupsSection(
      BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    final List<dynamic> smallGroups = member['smallGroups'] as List<dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Small Groups',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...smallGroups.map((group) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.secondary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.secondary.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'group',
                      color: colorScheme.secondary,
                      size: 5.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group['name'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (group['role'] != null)
                        Text(
                          group['role'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
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
