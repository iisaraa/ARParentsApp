import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_gradients.dart';
import '../../core/themes/app_text_styles.dart';
import '../../main.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _login() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty) {
        _showSnackBar('please_enter_email'.tr(), AppColors.errorLight);
        setState(() => _isLoading = false);
        return;
      }

      if (password.isEmpty) {
        _showSnackBar('please_enter_password'.tr(), AppColors.errorLight);
        setState(() => _isLoading = false);
        return;
      }

      await supabase.auth.signInWithPassword(email: email, password: password);

      if (mounted) {
        _showSnackBar('login_successful'.tr(), AppColors.successLight);
      }
    } on AuthException catch (error) {
      if (mounted) {
        _showSnackBar(error.message, AppColors.errorLight);
      }
    } catch (_) {
      if (mounted) {
        _showSnackBar('unexpected_error'.tr(), AppColors.errorLight);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
          (data) {
        if (_redirecting) return;

        final session = data.session;
        if (session != null && mounted) {
          _redirecting = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      onError: (error) {
        if (error is AuthException && mounted) {
          _showSnackBar(error.message, AppColors.errorLight);
        } else if (mounted) {
          _showSnackBar('unexpected_error'.tr(), AppColors.errorLight);
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.backgroundGradient(isDark),
        ),
        child: Stack(
          children: [
            // Background glass overlay
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
                  padding: const EdgeInsets.all(25),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // App Logo
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
                                Icons.family_restroom,
                                size: 45,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Welcome Title
                            Text(
                              'welcome_back'.tr(),
                              style: AppTextStyles.headerLarge(isDark).copyWith(
                                fontSize: 40,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'sign_in_to_continue'.tr(),
                              style: AppTextStyles.bodyMedium(isDark).copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Email Field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'email'.tr(),
                                  labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'password'.tr(),
                                  labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: _isLoading ? null : _login,
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
                                  'login'.tr(),
                                  style: AppTextStyles.buttonText(isDark).copyWith(
                                    fontSize: 18,
                                    color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Create Account Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'dont_have_account'.tr(),
                                  style: AppTextStyles.bodyMedium(isDark).copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SignupPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'create_account'.tr(),
                                    style: AppTextStyles.labelMedium(isDark).copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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