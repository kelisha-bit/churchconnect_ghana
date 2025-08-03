import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RegisterPromptWidget extends StatelessWidget {
  const RegisterPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New Member? ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Navigate to registration screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Registration feature coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
