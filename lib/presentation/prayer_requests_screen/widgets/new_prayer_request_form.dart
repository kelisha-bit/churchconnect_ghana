import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NewPrayerRequestForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onCancel;

  const NewPrayerRequestForm({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<NewPrayerRequestForm> createState() => _NewPrayerRequestFormState();
}

class _NewPrayerRequestFormState extends State<NewPrayerRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'General';
  String _selectedPrivacy = 'Public';
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General',
    'Health',
    'Family',
    'Work',
    'Spiritual',
    'Financial',
    'Relationships',
    'Ministry',
  ];

  final List<Map<String, dynamic>> _privacyOptions = [
    {
      'value': 'Public',
      'label': 'Public',
      'description': 'All church members can see',
      'icon': 'public',
    },
    {
      'value': 'Small Group Only',
      'label': 'Small Group',
      'description': 'Only your small group members',
      'icon': 'group',
    },
    {
      'value': 'Pastoral Team Only',
      'label': 'Pastoral Team',
      'description': 'Only pastoral team members',
      'icon': 'admin_panel_settings',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleField(context),
                    SizedBox(height: 3.h),
                    _buildDescriptionField(context),
                    SizedBox(height: 3.h),
                    _buildCategorySelection(context),
                    SizedBox(height: 3.h),
                    _buildPrivacySelection(context),
                    SizedBox(height: 3.h),
                    _buildAnonymousOption(context),
                    SizedBox(height: 4.h),
                    _buildSubmitButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              IconButton(
                onPressed: widget.onCancel,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: colorScheme.onSurface,
                  size: 24,
                ),
              ),
              Expanded(
                child: Text(
                  'New Prayer Request',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 48), // Balance the close button
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title (Optional)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Brief title for your prayer request...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: CustomIconWidget(
                iconName: 'title',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
            ),
          ),
          maxLength: 100,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prayer Request *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText:
                'Share your prayer request with the church family. Remember that God hears every prayer and cares about every detail of your life...',
            alignLabelWithHint: true,
          ),
          maxLines: 6,
          maxLength: 1000,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your prayer request';
            }
            if (value.trim().length < 10) {
              return 'Please provide more details (at least 10 characters)';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildCategorySelection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = category);
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  category,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrivacySelection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Level',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Column(
          children: _privacyOptions.map((option) {
            final isSelected = _selectedPrivacy == option['value'];
            return Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedPrivacy = option['value']);
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: option['icon'],
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['label'],
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              option['description'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnonymousOption(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'visibility_off',
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post Anonymously',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Your name will not be shown with this request',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isAnonymous,
            onChanged: (value) {
              setState(() => _isAnonymous = value);
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = Theme.of(context);
    final canSubmit = _descriptionController.text.trim().length >= 10;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSubmit && !_isSubmitting ? _handleSubmit : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'send',
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

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final request = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'privacyLevel': _selectedPrivacy,
        'isAnonymous': _isAnonymous,
        'memberName': _isAnonymous ? 'Anonymous' : 'Current User',
        'timestamp': DateTime.now(),
        'prayerCount': 0,
        'isAnswered': false,
      };

      // Simulate API call
      await Future.delayed(Duration(milliseconds: 800));

      widget.onSubmit(request);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text('Request shared with church family'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share request. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
