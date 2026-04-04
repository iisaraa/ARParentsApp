import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../../../../core/network/supabase_client.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClientHelper supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await supabaseClient.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('login_failed'.tr());
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw ServerException(_mapAuthError(e.message));
    } catch (e) {
      throw ServerException('unexpected_error'.tr());
    }
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    try {
      final response = await supabaseClient.signUpWithEmail(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      if (response.user == null) {
        throw ServerException('registration_failed'.tr());
      }

      // Insert into parent table
      await supabaseClient.client.from('parent').insert({
        'id': response.user!.id,
        'email': email,
        'full_name': name,
        'created_at': DateTime.now().toIso8601String(),
      });

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw ServerException(_mapAuthError(e.message));
    } catch (e) {
      throw ServerException('unexpected_error'.tr());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.signOut();
    } catch (e) {
      throw ServerException('logout_failed'.tr());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = supabaseClient.getCurrentUser();
    if (user != null) {
      return UserModel.fromSupabaseUser(user);
    }
    return null;
  }

  String _mapAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'invalid_credentials'.tr();
    }
    if (message.contains('Email not confirmed')) {
      return 'email_not_confirmed'.tr();
    }
    if (message.contains('User already registered')) {
      return 'user_already_exists'.tr();
    }
    return message;
  }
}