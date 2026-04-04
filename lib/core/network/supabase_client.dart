import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/logger.dart';

class SupabaseClientHelper {
  final SupabaseClient _client;

  SupabaseClientHelper(this._client);

  SupabaseClient get client => _client;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Logger.error('Sign in failed', e);
      rethrow;
    }
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
    } catch (e) {
      Logger.error('Sign up failed', e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      Logger.error('Sign out failed', e);
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }
}