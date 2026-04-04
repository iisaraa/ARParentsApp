import 'dart:ui';
import 'package:ARKidsWorld/app/pages/profile_page.dart';
import 'package:ARKidsWorld/app/pages/reports_page.dart';
import 'package:ARKidsWorld/app/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../features/auth/data/models/child.dart';
import '../providers/auth_provider.dart';
import '../providers/child_provider.dart';
import 'add_child_page.dart';
import 'package:easy_localization/easy_localization.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}
class ChildrenListPage extends StatelessWidget {
  const ChildrenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final childProvider = Provider.of<ChildProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: childProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : childProvider.children.isEmpty
          ? _buildEmptyState(context, auth)
          : RefreshIndicator(
        color: Colors.white,
        onRefresh: () async {
          if (auth.currentParent != null) {
            await childProvider.loadChildren(auth.currentParent!.id);
          }
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: childProvider.children.length,
          itemBuilder: (context, index) {
            final child = childProvider.children[index];
            return _buildGlassChildCard(child, context);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AuthProvider auth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.child_care,
              size: 60,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'no children'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'tap add child'.tr(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddChildPage(),
                ),
              );
              if (result == true && auth.currentParent != null) {
                await Provider.of<ChildProvider>(context, listen: false)
                    .loadChildren(auth.currentParent!.id);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 20,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'add child'.tr(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassChildCard(Child child, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          child.gender == 'Male'.tr()
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.pink.withOpacity(0.5),
                          child.gender == 'Male'.tr()
                              ? Colors.blue.withOpacity(0.3)
                              : Colors.pink.withOpacity(0.3),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      child.gender == 'Male'.tr() ? Icons.boy : Icons.girl,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.username,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildInfoChip(
                              icon: Icons.cake,
                              label: '${child.age} ${child.age == 1 ? 'year'.tr() : 'years'}'.tr(),
                            ),
                            _buildInfoChip(
                              icon: child.gender == 'Male'.tr()
                                  ? Icons.male
                                  : Icons.female,
                              label: child.gender,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.edit_outlined,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        icon: Icons.delete_outline,
                        onPressed: () {
                          _showDeleteDialog(context, child);
                        },
                        isDelete: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isDelete = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDelete
            ? Colors.red.withOpacity(0.4)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.white),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.zero,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Child child) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF6B5B95).withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:  Text(
          'Delete Child'.tr(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete ${child.username}?'.tr(),
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final childProvider = Provider.of<ChildProvider>(
                context,
                listen: false,
              );
              final success = await childProvider.deleteChild(child.id);
              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('Child deleted successfully'.tr()),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child:  Text('Delete'.tr()),
          ),
        ],
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
bool _isLoggingOut = false;
late final isDark = Theme.of(context).brightness == Brightness.dark;

  final List<Widget> _pages = [
    const ChildrenListPage(),
    const ReportsPage(),
    const SettingsPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.refreshParentData();
      await _loadChildren();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _loadChildren() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.currentParent != null) {
        await Provider.of<ChildProvider>(
          context,
          listen: false,
        ).loadChildren(auth.currentParent!.id);
      }
    } catch (e) {
      print('Error loading children: $e');
    }
  }

  Future<void> _refreshData() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.currentParent != null) {
        await Provider.of<ChildProvider>(
          context,
          listen: false,
        ).loadChildren(auth.currentParent!.id);
      }
    } catch (e) {
      print('Error refreshing data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Failed to refresh data'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B5B95),
              Color(0xFF88B3E2),
              Color(0xFF6C9EBF),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AR Kids World'.tr(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BerkshireSwash',
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddChildPage(),
                                    ),
                                  );
                                  if (result == true) {
                                    final auth = Provider.of<AuthProvider>(
                                      context,
                                      listen: false,
                                    );
                                    if (auth.currentParent != null) {
                                      await Provider.of<ChildProvider>(
                                        context,
                                        listen: false,
                                      ).loadChildren(auth.currentParent!.id);
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Logout Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white),
                                onPressed: () async {
                                  try {
                                    // Show confirmation dialog
                                    final shouldLogout = await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierColor: Colors.black.withOpacity(0.5),
                                      builder: (context) => Dialog(
                                        backgroundColor: isDark ? AppColors.dialogBackgroundDark : AppColors.dialogBackgroundLight,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                          side: BorderSide(
                                            color: isDark ? AppColors.dialogBorderDark : AppColors.dialogBorderLight,
                                            width: 1,
                                          ),
                                        ),
                                        elevation: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(24),
                                            gradient: isDark
                                                ? LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.primaryDark.withOpacity(0.1),
                                                AppColors.secondaryDark.withOpacity(0.05),
                                              ],
                                            )
                                                : LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.primaryLight.withOpacity(0.05),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: AppColors.errorLight.withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.logout,
                                                  size: 32,
                                                  color: AppColors.errorLight,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                'logout'.tr(),
                                                style: AppTextStyles.headerSmall(isDark).copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                'are_you_sure_logout'.tr(),
                                                style: AppTextStyles.bodyMedium(isDark).copyWith(
                                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 24),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      style: OutlinedButton.styleFrom(
                                                        foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                                        side: BorderSide(
                                                          color: isDark ? AppColors.dialogBorderDark : AppColors.dialogBorderLight,
                                                        ),
                                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'cancel'.tr(),
                                                        style: AppTextStyles.labelMedium(isDark),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: AppColors.errorLight,
                                                        foregroundColor: Colors.white,
                                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        elevation: 2,
                                                      ),
                                                      child: Text(
                                                        'logout'.tr(),
                                                        style: AppTextStyles.buttonText(isDark).copyWith(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                    if (shouldLogout == true && mounted) {
                                      // Show loading indicator
                                      setState(() {
                                        _isLoggingOut = true;
                                      });

                                      // Sign out from Supabase
                                      await Supabase.instance.client.auth.signOut();

                                      // Clear local data
                                      final authProvider = Provider.of<AuthProvider>(
                                        context,
                                        listen: false,
                                      );
                                      await authProvider.logout();

                                      if (mounted) {
                                        // Navigate to login page - Use pushReplacement instead of pushAndRemoveUntil
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) => const LoginPage()),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    print('Error logging out: $e');
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('error_logging_out'.tr()),
                                          backgroundColor: AppColors.errorLight,
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isLoggingOut = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _pages[_currentIndex],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6B5B95),
                    Color(0xFF88B3E2),
                    Color(0xFF6C9EBF),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_outlined, 0, "Home".tr()),
                  _buildNavItem(Icons.receipt_long_outlined, 1, "Reports".tr()),
                  _buildNavItem(Icons.settings_outlined, 2, "Settings".tr()),
                  _buildNavItem(Icons.perm_identity_outlined, 3, "Profile".tr()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    bool selected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        if (index == 0 || index == 1) {
          _refreshData();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? Colors.white : Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? Colors.white : Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

}