import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_gradients.dart';
import '../../core/themes/app_text_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      print('🔄 Loading profile data...');
      print('Current parent before refresh: ${auth.currentParent?.username}');

      if (!auth.isProfileLoaded) {
        await auth.refreshParentData();
      }

      print('Current parent after refresh: ${auth.currentParent?.username}');
      print('Parent email: ${auth.currentParent?.email}');
      print('Parent full name: ${auth.currentParent?.fullName}');

      if (auth.currentParent == null) {
        setState(() {
          _errorMessage = 'no_user_data'.tr();
        });
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
      setState(() {
        _errorMessage = 'failed_load_profile'.tr();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _refreshProfile() async {
    await _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print('🔍 Building ProfilePage - Username: ${auth.currentParent?.username}');

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'profile'.tr(),
          style: AppTextStyles.headerMedium(isDark).copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshProfile,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
        ),
      )
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: AppColors.errorLight,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: AppTextStyles.bodyMedium(isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'retry'.tr(),
                style: AppTextStyles.buttonText(isDark),
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
        onRefresh: _refreshProfile,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppGradients.glassGradient(isDark),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                auth.currentParent?.fullName?.isNotEmpty == true
                    ? auth.currentParent!.fullName!
                    : auth.currentParent?.username ?? 'no_username'.tr(),
                style: AppTextStyles.headerSmall(isDark).copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  auth.currentParent?.id ?? 'no_id'.tr(),
                  style: AppTextStyles.bodySmall(isDark).copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Profile Info Card
              Container(
                decoration: BoxDecoration(
                  gradient: AppGradients.glassGradient(isDark),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      _buildProfileTile(
                        icon: Icons.email,
                        title: 'email'.tr(),
                        value: auth.currentParent?.email?.isNotEmpty == true
                            ? auth.currentParent!.email
                            : 'not_set'.tr(),
                        isDark: isDark,
                      ),
                      const Divider(
                        color: Colors.white24,
                        height: 1,
                      ),
                      _buildProfileTile(
                        icon: Icons.badge,
                        title: 'full_name'.tr(),
                        value: auth.currentParent?.fullName?.isNotEmpty == true
                            ? auth.currentParent!.fullName!
                            : 'not_set'.tr(),
                        isDark: isDark,
                      ),
                      const Divider(
                        color: Colors.white24,
                        height: 1,
                      ),
                      _buildProfileTile(
                        icon: Icons.calendar_today,
                        title: 'member_since'.tr(),
                        value: _formatDate(auth.currentParent?.createdAt),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Edit Profile Button
              // Container(
              //   width: double.infinity,
              //   height: 50,
              //   decoration: BoxDecoration(
              //     gradient: AppGradients.glassGradient(isDark),
              //     borderRadius: BorderRadius.circular(15),
              //     border: Border.all(
              //       color: Colors.white.withOpacity(0.3),
              //     ),
              //   ),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text(
              //             'edit profile coming soon'.tr(),
              //             style: AppTextStyles.bodySmall(isDark),
              //           ),
              //           backgroundColor: AppColors.warningLight,
              //           behavior: SnackBarBehavior.floating,
              //         ),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.transparent,
              //       shadowColor: Colors.transparent,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //     ),
              //     child: Text(
              //       'edit_profile'.tr(),
              //       style: AppTextStyles.buttonText(isDark),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium(isDark).copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium(isDark).copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'not_available'.tr();
    return '${date.day}/${date.month}/${date.year}';
  }
}
