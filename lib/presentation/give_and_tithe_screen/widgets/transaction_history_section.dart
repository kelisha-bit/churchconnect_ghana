import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock transaction data
    final List<Map<String, dynamic>> transactions = [
      {
        "id": "TXN001",
        "amount": "GHS 100.00",
        "purpose": "General Tithe",
        "method": "MTN Mobile Money",
        "date": DateTime.now().subtract(Duration(days: 7)),
        "status": "completed",
      },
      {
        "id": "TXN002",
        "amount": "GHS 50.00",
        "purpose": "Sunday Offering",
        "method": "Vodafone Cash",
        "date": DateTime.now().subtract(Duration(days: 14)),
        "status": "completed",
      },
      {
        "id": "TXN003",
        "amount": "GHS 200.00",
        "purpose": "Building Fund",
        "method": "MTN Mobile Money",
        "date": DateTime.now().subtract(Duration(days: 21)),
        "status": "completed",
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Recent Donations',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // Navigate to full transaction history
                },
                child: Text(
                  'View All',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Transaction List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return _buildTransactionItem(context, transaction);
            },
          ),

          SizedBox(height: 2.h),

          // View All Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // Navigate to full transaction history
              },
              child: Text('View All Transactions'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, Map<String, dynamic> transaction) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final date = transaction['date'] as DateTime;
    final formattedDate = '${date.day}/${date.month}/${date.year}';

    return Container(
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
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'check_circle',
              color: colorScheme.tertiary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['purpose'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${transaction['method']} • $formattedDate',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction['amount'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(height: 0.5.h),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _downloadReceipt(context, transaction);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'download',
                        color: colorScheme.secondary,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Receipt',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.secondary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _downloadReceipt(
      BuildContext context, Map<String, dynamic> transaction) {
    // Mock receipt download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Receipt for ${transaction['id']} downloaded successfully'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}
