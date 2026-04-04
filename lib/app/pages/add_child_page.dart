import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_gradients.dart';
import '../../core/themes/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../providers/child_provider.dart';

class AddChildPage extends StatefulWidget {
  const AddChildPage({super.key});

  @override
  State<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends State<AddChildPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _addChild() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('passwords_do_not_match'.tr()),
          backgroundColor: AppColors.errorLight,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final childProvider = Provider.of<ChildProvider>(context, listen: false);

      final parentId = auth.currentParent?.id;

      final session = Supabase.instance.client.auth.currentSession;
      print('Session user ID: ${session?.user.id}');
      print('Session user email: ${session?.user.email}');

      final effectiveParentId = parentId ?? session?.user.id;

      if (effectiveParentId == null) {
        throw Exception('no_parent_id_found'.tr());
      }

      print('✅ Using parent ID: $effectiveParentId');

      final success = await childProvider.addChild(
        parentId: effectiveParentId,
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('child_added_successfully'.tr()),
            backgroundColor: AppColors.successLight,
          ),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(childProvider.errorMessage ?? 'failed_to_add_child'.tr()),
            backgroundColor: AppColors.errorLight,
          ),
        );
      }
    } catch (e) {
      print('❌ Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error: ${e.toString()}'),
            backgroundColor: AppColors.errorLight,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'add_new_child'.tr(),
          style: AppTextStyles.headerMedium(isDark).copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.backgroundGradient(isDark),
        ),
        child: Stack(
          children: [
            // Glass overlay effect
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(isDark ? 0.05 : 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 500),
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: AppGradients.glassGradient(isDark),
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.child_care,
                                  size: 45,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Title
                              Text(
                                'add_new_child'.tr(),
                                style: AppTextStyles.headerMedium(isDark).copyWith(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'enter_child_information'.tr(),
                                style: AppTextStyles.bodyMedium(isDark).copyWith(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Username Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _usernameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'username'.tr(),
                                    labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_username'.tr();
                                    }
                                    if (value.length < 3) {
                                      return 'username_min_length'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Password Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'password'.tr(),
                                    labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_password'.tr();
                                    }
                                    if (value.length < 4) {
                                      return 'password_min_length'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Confirm Password Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'confirm_password'.tr(),
                                    labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_confirm_password'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Age Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'age'.tr(),
                                    labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.cake,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_age'.tr();
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age < 1 || age > 18) {
                                      return 'age_range'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Gender Dropdown
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  style: const TextStyle(color: Colors.white),
                                  dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                  decoration: InputDecoration(
                                    labelText: 'gender'.tr(),
                                    labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.people,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: [
                                     DropdownMenuItem(
                                      value: 'Male',
                                      child: Text('male'.tr()),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Female',
                                      child: Text('female'.tr()),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Add Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _addChild,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                                    ),
                                  )
                                      : Text(
                                    'add_child'.tr(),
                                    style: AppTextStyles.buttonText(isDark).copyWith(
                                      fontSize: 16,
                                      color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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