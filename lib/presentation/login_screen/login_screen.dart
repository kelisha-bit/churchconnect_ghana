import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/church_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/register_prompt_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _showBiometricPrompt = false;
  String _errorMessage = '';

  // Mock credentials for testing
  final List<Map<String, String>> _mockCredentials = [
    {
      'email': 'pastor@greatworks.gh',
      'password': 'pastor123',
      'role': 'Pastor',
    },
    {
      'email': 'admin@greatworks.gh',
      'password': 'admin123',
      'role': 'Admin',
    },
    {
      'email': 'member@greatworks.gh',
      'password': 'member123',
      'role': 'Member',
    },
    {
      'email': '+233244567890',
      'password': 'phone123',
      'role': 'Member',
    },
    {
      'email': '0244567890',
      'password': 'phone123',
      'role': 'Member',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('saved_email');
      if (savedEmail != null) {
        // Email will be pre-filled in the form
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveCredentials(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 1500));

      // Check mock credentials
      final credential = _mockCredentials.firstWhere(
        (cred) => cred['email'] == email && cred['password'] == password,
        orElse: () => {},
      );

      if (credential.isEmpty) {
        setState(() {
          _errorMessage = 'Invalid email/phone or password. Please try again.';
          _isLoading = false;
        });

        HapticFeedback.heavyImpact();
        _showErrorSnackBar(_errorMessage);
        return;
      }

      // Save credentials for next time
      await _saveCredentials(email);

      // Check if biometric should be shown (first time login)
      final prefs = await SharedPreferences.getInstance();
      final biometricEnabled = prefs.getBool('biometric_enabled') ?? false;

      if (!biometricEnabled) {
        setState(() {
          _isLoading = false;
          _showBiometricPrompt = true;
        });
        return;
      }

      // Success - navigate to home
      _navigateToHome();
    } catch (e) {
      setState(() {
        _errorMessage =
            'Network error. Please check your connection and try again.';
        _isLoading = false;
      });

      HapticFeedback.heavyImpact();
      _showErrorSnackBar(_errorMessage);
    }
  }

  Future<void> _handleBiometricSetup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate biometric setup
      await Future.delayed(Duration(milliseconds: 1000));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometric_enabled', true);

      _navigateToHome();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(
          'Biometric setup failed. You can enable it later in settings.');
    }
  }

  void _skipBiometric() {
    _navigateToHome();
  }

  void _navigateToHome() {
    HapticFeedback.lightImpact();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-dashboard-screen',
      (route) => false,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: AppTheme.lightTheme.colorScheme.onError,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Login Content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),

                      // Church Logo Section
                      ChurchLogoWidget(),

                      SizedBox(height: 6.h),

                      // Login Form Section
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        isLoading: _isLoading,
                      ),

                      Spacer(),

                      // Register Prompt
                      RegisterPromptWidget(),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),

            // Biometric Prompt Overlay
            if (_showBiometricPrompt)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: BiometricPromptWidget(
                      onBiometricLogin: _handleBiometricSetup,
                      onSkip: _skipBiometric,
                      isLoading: _isLoading,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
