import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/models/child.dart';

class ChildProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Child> _children = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoaded = false;

  List<Child> get children => _children;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ✅ تحميل الأطفال (مع caching)
  Future<void> loadChildren(String parentId, {bool forceRefresh = false}) async {
    if (_isLoaded && !forceRefresh) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('child')
          .select()
          .eq('parent_id', parentId);

      _children = (response as List)
          .map((e) => Child.fromJson(e))
          .toList();

      _isLoaded = true;
    } catch (e) {
      debugPrint('Error loading children: $e');
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ إضافة طفل
  Future<bool> addChild({
    required String parentId,
    required String username,
    required String password,
    required int age,
    required String gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final childData = {
        'parent_id': parentId,
        'username': username,
        'password': password,
        'age': age,
        'gender': gender,
      };

      final response = await _supabase
          .from('child')
          .insert(childData)
          .select();

      // ✅ أضف الطفل مباشرة بدون إعادة تحميل
      final newChild = Child.fromJson(response[0]);
      _children.add(newChild);

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('❌ Error adding child: $e');
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ حذف طفل
  Future<bool> deleteChild(String childId) async {
    try {
      await _supabase
          .from('child')
          .delete()
          .eq('id', childId);

      _children.removeWhere((c) => c.id == childId);
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Child deletion error: $e');
      return false;
    }
  }

  // ✅ إعادة ضبط الكاش
  void reset() {
    _isLoaded = false;
  }
}