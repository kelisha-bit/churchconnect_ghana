import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;
  final TextEditingController phoneController;
  final Function(String) onPhoneChanged;

  const PaymentMethodSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    required this.phoneController,
    required this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final paymentMethods = [
      {
        'id': 'mtn',
        'name': 'MTN Mobile Money',
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/MTN_Logo.svg/1200px-MTN_Logo.svg.png',
        'color': Color(0xFFFFCC00),
      },
      {
        'id': 'vodafone',
        'name': 'Vodafone Cash',
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Vodafone_icon.svg/1200px-Vodafone_icon.svg.png',
        'color': Color(0xFFE60000),
      },
      {
        'id': 'airteltigo',
        'name': 'AirtelTigo Money',
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Airtel_logo.svg/1200px-Airtel_logo.svg.png',
        'color': Color(0xFFED1C24),
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'payment',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Payment Method',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Payment Method Options
          Column(
            children: paymentMethods.map((method) {
              final isSelected = selectedPaymentMethod == method['id'];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onPaymentMethodChanged(method['id'] as String);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              offset: Offset(0, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl: method['logo'] as String,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          method['name'] as String,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: colorScheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Phone Number Input
          if (selectedPaymentMethod.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Text(
              'Phone Number',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: '0XX XXX XXXX',
                  prefixText: '+233 ',
                  prefixStyle: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(4.w),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'phone',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                onChanged: onPhoneChanged,
              ),
            ),
          ],

          // Saved Methods
          if (selectedPaymentMethod.isNotEmpty) ...[
            SizedBox(height: 2.h),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                // Show saved payment methods
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.secondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'bookmark',
                      color: colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Use Saved Method',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
