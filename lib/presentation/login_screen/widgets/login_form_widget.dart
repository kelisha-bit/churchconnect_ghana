import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    super.key,
    required this.onLogin,
    required this.isLoading,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _isValidEmailOrPhone(_emailController.text);

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  bool _isValidEmailOrPhone(String input) {
    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailRegex.hasMatch(input)) return true;

    // Ghana phone number validation (+233 format)
    final phoneRegex = RegExp(r'^\+233[0-9]{9}$|^0[0-9]{9}$');
    return phoneRegex.hasMatch(input);
  }

  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or phone number';
    }

    if (!_isValidEmailOrPhone(value)) {
      return 'Please enter a valid email or Ghana phone number';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.lightImpact();
      widget.onLogin(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email/Phone Input Field
          TextFormField(
            controller: _emailController,
            keyboardType: _emailController.text.startsWith('+233') ||
                    _emailController.text.startsWith('0')
                ? TextInputType.phone
                : TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Email or Phone Number',
              hintText: 'Enter email or +233XXXXXXXXX',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ),
            validator: _validateEmailOrPhone,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),

          SizedBox(height: 3.h),

          // Password Input Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                onPressed: widget.isLoading
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
              ),
            ),
            validator: _validatePassword,
            onFieldSubmitted: (_) => _handleLogin(),
          ),

          SizedBox(height: 2.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      // Navigate to forgot password screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Forgot password feature coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: ElevatedButton(
              onPressed:
                  (_isFormValid && !widget.isLoading) ? _handleLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.12),
                foregroundColor: _isFormValid
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.38),
                elevation: _isFormValid ? 2.0 : 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
