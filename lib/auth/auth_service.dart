// auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // CORRECTED: Use the proper stream type
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  // Sign up with email and password
  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Sign in with email and password
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Get user metadata (where we'll store tasks)
  Map<String, dynamic>? getUserMetadata() {
    return _supabase.auth.currentUser?.userMetadata;
  }

  // Update user metadata with tasks
  Future<void> updateUserMetadata(Map<String, dynamic> metadata) async {
    await _supabase.auth.updateUser(
      UserAttributes(data: metadata),
    );
  }

  // Check if email is verified
  bool isEmailVerified() {
    return _supabase.auth.currentUser?.emailConfirmedAt != null;
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    await _supabase.auth.resend(
      type: OtpType.signup,
      email: _supabase.auth.currentUser!.email!,
    );
  }
}