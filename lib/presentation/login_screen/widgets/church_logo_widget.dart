import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChurchLogoWidget extends StatelessWidget {
  const ChurchLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Church Logo Container
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'church',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 12.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Church Name
        Text(
          'Greater Works City Church',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            letterSpacing: 0.15,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'ChurchConnect Ghana',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.25,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
