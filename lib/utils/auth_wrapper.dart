import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/home_dashboard_screen/home_dashboard_screen.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService.instance;
  bool _isLoading = true;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    _listenToAuthChanges();
  }

  void _checkAuthState() {
    setState(() {
      _isSignedIn = _authService.isSignedIn;
      _isLoading = false;
    });
  }

  void _listenToAuthChanges() {
    _authService.authStateChanges.listen((authState) {
      setState(() {
        _isSignedIn = authState.session != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Development Mode: Allow access to all screens regardless of auth state
    // TODO: Before production deployment
    // 1. Remove this development mode section
    // 2. Test all authentication flows
    // 3. Verify role-based access controls

    return _isSignedIn ? const HomeDashboardScreen() : const LoginScreen();
  }
}
