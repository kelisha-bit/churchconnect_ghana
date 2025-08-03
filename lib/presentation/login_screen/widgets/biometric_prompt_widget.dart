import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricPromptWidget extends StatelessWidget {
  final VoidCallback onBiometricLogin;
  final VoidCallback onSkip;
  final bool isLoading;

  const BiometricPromptWidget({
    super.key,
    required this.onBiometricLogin,
    required this.onSkip,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Biometric Icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 10.w,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Text(
            'Enable Biometric Login',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Description
          Text(
            'Use your fingerprint or face ID to login quickly and securely next time.',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Action Buttons
          Row(
            children: [
              // Skip Button
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          onSkip();
                        },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // Enable Button
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          onBiometricLogin();
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Enable',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
