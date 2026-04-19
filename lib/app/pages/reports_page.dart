import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../features/auth/data/models/child.dart';
import '../providers/app_provider.dart';
import '../providers/child_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final isDark = appProvider.isDarkMode;
        final childProvider = Provider.of<ChildProvider>(context);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: childProvider.children.isEmpty
              ? Center(
            child: _buildGlassCard(
              isDark: isDark,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 80,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No data found',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add children to view reports',
                    style: TextStyle(
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildGlassCard(
                  isDark: isDark,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Quick Statics'.tr(),
                          style: AppTextStyles.headerSmall(isDark).copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard(
                              'Children number'.tr(),
                              childProvider.children.length.toString(),
                              Icons.child_care,
                              isDark
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                              isDark,
                            ),
                            _buildStatCard(
                              'Males'.tr(),
                              _countByGender(childProvider.children, 'Male'),
                              Icons.male,
                              AppColors.info,
                              isDark,
                            ),
                            _buildStatCard(
                              'Females'.tr(),
                              _countByGender(
                                childProvider.children,
                                'Female',
                              ),
                              Icons.female,
                              AppColors.warning,
                              isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildGlassCard(
                  isDark: isDark,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Children List',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                        ).tr(),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: childProvider.children.length,
                          separatorBuilder: (context, index) =>
                              Divider(
                                color: isDark
                                    ? AppColors.dividerDark.withOpacity(0.3)
                                    : AppColors.dividerLight.withOpacity(0.3),
                              ),
                          itemBuilder: (context, index) {
                            final child = childProvider.children[index];
                            return ListTile(
                              leading: Icon(
                                child.gender == 'Male'
                                    ? Icons.boy
                                    : Icons.girl,
                                color: child.gender == 'Male'
                                    ? AppColors.info
                                    : AppColors.warning,
                              ),
                              title: Text(
                                child.username,
                                style: TextStyle(
                                  color: isDark ? AppColors.textDark : AppColors.textLight,
                                ),
                              ),
                              subtitle: Text(
                                'Age: ${child.age} Year ',
                                style: TextStyle(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                              trailing: Text(
                                child.gender == 'Male'
                                    ? 'Male'.tr()
                                    : 'Female'.tr(),
                                style: AppTextStyles.labelMedium(isDark)
                                    .copyWith(
                                  color: child.gender == 'Male'
                                      ? AppColors.info
                                      : AppColors.warning,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassCard({
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ]
              : [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.25),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isDark ? 6 : 8,
            sigmaY: isDark ? 6 : 8,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      bool isDark,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(isDark ? 0.15 : 0.12),
            color.withOpacity(isDark ? 0.05 : 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(isDark ? 0.2 : 0.25),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.25),
                  color.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headerMedium(isDark).copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.labelMedium(isDark).copyWith(
              fontSize: 11,
              color: isDark
                  ? AppColors.textSecondaryDark.withOpacity(0.9)
                  : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _countByGender(List<Child> children, String gender) {
    return children.where((child) => child.gender == gender).length.toString();
  }
}