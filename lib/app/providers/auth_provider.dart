import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/models/parent.dart';
import '../../main.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Parent? _currentParent;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isProfileLoaded = false;

  Parent? get currentParent => _currentParent;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _currentParent != null;

  bool get isProfileLoaded => _isProfileLoaded;

  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSavedParent();
    // Also try to get from session if available
    await _loadFromSession();
  }

  Future<void> _loadSavedParent() async {
    try {
      final parentData = await _storage.read(key: 'parent_data');
      if (parentData != null) {
        _currentParent = Parent.fromJson(json.decode(parentData));
        print('✅ Loaded parent from storage: ${_currentParent?.username}');
        notifyListeners();
      } else {
        print('⚠️ No parent data in storage');
      }
    } catch (e) {
      print('Error loading parent data: $e');
    }
  }

  Future<void> _loadFromSession() async {
    final session = _supabase.auth.currentSession;
    if (session != null && _currentParent == null) {
      print('🔄 Loading parent from session...');
      await refreshParentData();
    }
  }

  Future<bool> registerParent({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('========== Registering Parent ==========');
      print('Email: $email');
      print('Username: $username');

      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username, 'full_name': fullName ?? ''},
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create user');
      }

      final userId = authResponse.user!.id;
      print('✅ User created in Auth: $userId');

      final parentData = {
        'id': userId,
        'email': email,
        'username': username,
        'password': password,
        'full_name': fullName ?? '',
      };

      await _supabase.from('parent').insert(parentData);
      print('✅ Parent data stored in parent table');

      _currentParent = Parent(
        id: userId,
        email: email,
        username: username,
        fullName: fullName,
        createdAt: DateTime.now(),
        password: password,
      );

      await _storage.write(
        key: 'parent_data',
        value: json.encode(_currentParent!.toJson()),
      );

      print('========== ✅ Registration Successful ==========');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Registration error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginParent(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('========== Parent Login ==========');
      print('Email: $email');

      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Failed to login');
      }

      final userId = authResponse.user!.id;
      print('✅ Login successful: $userId');

      // Wait a moment for session to be fully established
      await Future.delayed(const Duration(milliseconds: 500));

      // Fetch parent data
      await _fetchAndSetParentData(userId, email, password);

      print('========== ✅ Login Successful ==========');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Login error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _fetchAndSetParentData(
      String userId,
      String email,
      String password,
      ) async {
    print('🔍 Fetching parent data for user: $userId');

    try {
      final response = await _supabase.from('parent').select().eq('id', userId);

      print('Database response: $response');

      if (response.isNotEmpty) {
        final parentData = response.first;
        _currentParent = Parent.fromJson(parentData);
        print('✅ Parent data loaded: ${_currentParent?.username}');
        print('   Email: ${_currentParent?.email}');
        print('   Full Name: ${_currentParent?.fullName}');
      } else {
        print('⚠️ Parent not found, creating...');
        final newParentData = {
          'id': userId,
          'email': email,
          'username': email.split('@').first,
          'password': password,
          'full_name': '',
          'phone': '',
        };

        await _supabase.from('parent').insert(newParentData);
        _currentParent = Parent.fromJson(newParentData);
        print('✅ Parent created: ${_currentParent?.username}');
      }

      // Save to local storage
      await _storage.write(
        key: 'parent_data',
        value: json.encode(_currentParent!.toJson()),
      );

      print('✅ Parent data saved to storage');
    } catch (e) {
      print('❌ Error fetching parent data: $e');
      rethrow;
    }
  }

  Future<void> refreshParentData({bool forceRefresh = false}) async {
    if (_isProfileLoaded && !forceRefresh) return;

    try {
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) return;

      final response = await _supabase
          .from('parent')
          .select()
          .eq('id', userId)
          .single();

      _currentParent = Parent.fromJson(response);

      _isProfileLoaded = true; // 👈 نحفظ إنه اتحمّل

      notifyListeners();
    } catch (e) {
      print('❌ Error refreshing parent: $e');
    }
  }

  Future<void> updateUsername(String newUsername) async {
    final session = _supabase.auth.currentSession;
    if (session == null) return;

    try {
      await _supabase
          .from('parent')
          .update({'username': newUsername})
          .eq('id', session.user.id);

      await refreshParentData();
      print('✅ Username updated to: $newUsername');
    } catch (e) {
      print('❌ Error updating username: $e');
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    // Provider.of<AuthProvider>(context, listen: false).resetProfile();
    await _storage.delete(key: 'parent_data');
    _currentParent = null;
    notifyListeners();
    print('👋 Logged out');
  }
  void resetProfile() {
    _isProfileLoaded = false;
    _currentParent = null;
  }
}