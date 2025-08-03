import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/amount_input_section.dart';
import './widgets/biblical_verse_section.dart';
import './widgets/giving_frequency_toggle.dart';
import './widgets/giving_option_card.dart';
import './widgets/payment_method_section.dart';
import './widgets/purpose_dropdown.dart';
import './widgets/security_badges.dart';
import './widgets/transaction_history_section.dart';

class GiveAndTitheScreen extends StatefulWidget {
  const GiveAndTitheScreen({super.key});

  @override
  State<GiveAndTitheScreen> createState() => _GiveAndTitheScreenState();
}

class _GiveAndTitheScreenState extends State<GiveAndTitheScreen> {
  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _customPurposeController =
      TextEditingController();

  // State variables
  String _selectedGivingOption = 'tithe';
  String _selectedPaymentMethod = '';
  String _selectedPurpose = 'tithe';
  bool _isRecurring = false;
  bool _isProcessing = false;
  int _currentBottomNavIndex = 2; // Give tab

  // Mock giving options data
  final List<Map<String, dynamic>> _givingOptions = [
    {
      'id': 'tithe',
      'title': 'Tithe',
      'description': 'Your faithful 10% offering to God',
      'icon': 'volunteer_activism',
      'suggestedAmount': 'GHS 100',
    },
    {
      'id': 'offering',
      'title': 'Offering',
      'description': 'Sunday service offering',
      'icon': 'church',
      'suggestedAmount': 'GHS 50',
    },
    {
      'id': 'special',
      'title': 'Special Projects',
      'description': 'Support church building and expansion',
      'icon': 'home_work',
      'suggestedAmount': 'GHS 200',
    },
    {
      'id': 'missions',
      'title': 'Missions',
      'description': 'Support global evangelism efforts',
      'icon': 'public',
      'suggestedAmount': 'GHS 75',
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    _customPurposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar.secondary(
        title: 'Give & Tithe',
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _showGivingInfo(context);
            },
            icon: CustomIconWidget(
              iconName: 'info_outline',
              color: colorScheme.primary,
              size: 24,
            ),
            tooltip: 'Giving Information',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SSL Security Indicator
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: colorScheme.tertiary.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'lock',
                    color: colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Secure SSL Encrypted Payment',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Giving Options
            Text(
              'Choose Your Giving Type',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _givingOptions.length,
              itemBuilder: (context, index) {
                final option = _givingOptions[index];
                return GivingOptionCard(
                  title: option['title'],
                  description: option['description'],
                  iconName: option['icon'],
                  suggestedAmount: option['suggestedAmount'],
                  isSelected: _selectedGivingOption == option['id'],
                  onTap: () => _selectGivingOption(option['id']),
                );
              },
            ),

            SizedBox(height: 2.h),

            // Amount Input Section
            AmountInputSection(
              amountController: _amountController,
              onAmountChanged: _onAmountChanged,
              onPresetAmountSelected: _onPresetAmountSelected,
            ),

            // Payment Method Section
            PaymentMethodSection(
              selectedPaymentMethod: _selectedPaymentMethod,
              onPaymentMethodChanged: _onPaymentMethodChanged,
              phoneController: _phoneController,
              onPhoneChanged: _onPhoneChanged,
            ),

            // Giving Frequency Toggle
            GivingFrequencyToggle(
              isRecurring: _isRecurring,
              onFrequencyChanged: _onFrequencyChanged,
            ),

            // Purpose Dropdown
            PurposeDropdown(
              selectedPurpose: _selectedPurpose,
              onPurposeChanged: _onPurposeChanged,
              customPurposeController: _customPurposeController,
            ),

            // Give Now Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canProcessPayment() ? _processPayment : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor:
                      colorScheme.onSurface.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'favorite',
                            color: colorScheme.onPrimary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Give Now',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Security Badges
            SecurityBadges(),

            // Biblical Verse Section
            BiblicalVerseSection(),

            // Transaction History
            TransactionHistorySection(),

            SizedBox(height: 10.h), // Bottom padding for navigation
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar.main(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  void _selectGivingOption(String optionId) {
    setState(() {
      _selectedGivingOption = optionId;
      _selectedPurpose = optionId; // Auto-select matching purpose
    });
    HapticFeedback.lightImpact();
  }

  void _onAmountChanged(String value) {
    // Amount validation can be added here
  }

  void _onPresetAmountSelected(String amount) {
    setState(() {
      _amountController.text = amount;
    });
  }

  void _onPaymentMethodChanged(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _onPhoneChanged(String value) {
    // Phone number validation can be added here
  }

  void _onFrequencyChanged(bool isRecurring) {
    setState(() {
      _isRecurring = isRecurring;
    });
  }

  void _onPurposeChanged(String purpose) {
    setState(() {
      _selectedPurpose = purpose;
    });
  }

  bool _canProcessPayment() {
    return _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0 &&
        _selectedPaymentMethod.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _phoneController.text.length >= 9 &&
        !_isProcessing;
  }

  Future<void> _processPayment() async {
    if (!_canProcessPayment()) return;

    setState(() {
      _isProcessing = true;
    });

    HapticFeedback.mediumImpact();

    try {
      // Simulate payment processing
      await Future.delayed(Duration(seconds: 3));

      // Show success dialog
      _showPaymentSuccess();
    } catch (e) {
      // Show error dialog
      _showPaymentError(e.toString());
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: Theme.of(context).colorScheme.tertiary,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Donation Successful!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Thank you for your generous gift of GHS ${_amountController.text}. Your donation will make a difference in our community.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _shareTestimony();
                    },
                    child: Text('Share'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetForm();
                    },
                    child: Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Payment Failed'),
          ],
        ),
        content: Text(
          'We encountered an issue processing your donation. Please check your mobile money balance and try again.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processPayment();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _shareTestimony() {
    // Mock sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for sharing your testimony of giving!'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _phoneController.clear();
      _customPurposeController.clear();
      _selectedGivingOption = 'tithe';
      _selectedPaymentMethod = '';
      _selectedPurpose = 'tithe';
      _isRecurring = false;
    });
  }

  void _showGivingInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'About Giving',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(
                        'Our Mission',
                        'Your generous donations help us spread the Gospel, support our community, and expand God\'s kingdom through various ministries and outreach programs.',
                        'church',
                      ),
                      _buildInfoSection(
                        'How We Use Your Gifts',
                        '• 40% - Ministry Operations\n• 25% - Community Outreach\n• 20% - Building & Maintenance\n• 15% - Missions & Evangelism',
                        'pie_chart',
                      ),
                      _buildInfoSection(
                        'Financial Transparency',
                        'We provide monthly financial reports to all members showing how donations are used. All financial records are audited annually by certified accountants.',
                        'visibility',
                      ),
                      _buildInfoSection(
                        'Tax Benefits',
                        'All donations to Greater Works City Church are tax-deductible. You will receive a receipt for your records and annual giving statement.',
                        'receipt',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;

    setState(() {
      _currentBottomNavIndex = index;
    });

    // Navigation handled by CustomBottomBar
  }
}
