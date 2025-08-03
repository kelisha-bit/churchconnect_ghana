import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Get current session
  Session? get currentSession => _client.auth.currentSession;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return response;
    } catch (error) {
      throw Exception('Sign up failed: $error');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign in failed: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // Update user password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (error) {
      throw Exception('Password update failed: $error');
    }
  }

  // Update user email
  Future<UserResponse> updateEmail(String newEmail) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(email: newEmail),
      );
      return response;
    } catch (error) {
      throw Exception('Email update failed: $error');
    }
  }

  // Get user profile from profiles table
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (!isSignedIn) return null;

      final response = await _client
          .from('profiles')
          .select()
          .eq('user_id', currentUser!.id)
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Create or update user profile
  Future<void> upsertUserProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? email,
    String role = 'member',
  }) async {
    try {
      if (!isSignedIn) throw Exception('User not signed in');

      await _client.from('profiles').upsert({
        'user_id': currentUser!.id,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email ?? currentUser!.email,
        'role': role,
      });
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }

  // Check if user is admin
  Future<bool> isAdmin() async {
    try {
      final profile = await getUserProfile();
      return profile?['role'] == 'admin';
    } catch (error) {
      return false;
    }
  }

  // Sign in with OAuth (Google, Apple, etc.)
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    try {
      return await _client.auth.signInWithOAuth(provider);
    } catch (error) {
      throw Exception('OAuth sign in failed: $error');
    }
  }
}
