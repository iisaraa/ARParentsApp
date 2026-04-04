import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../features/auth/data/models/child.dart';
import '../providers/child_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final childProvider = Provider.of<ChildProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: childProvider.children.isEmpty
          ? Center(
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
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    color: Colors.white.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Quick Statics'.tr(),
                            style: AppTextStyles.headerSmall(isDark).copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                                Colors.blue,
                                isDark,
                              ),
                              _buildStatCard(
                                'Females'.tr(),
                                _countByGender(
                                  childProvider.children,
                                  'Female',
                                ),
                                Icons.female,
                                Colors.pink,
                                isDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.white.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Children List',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: childProvider.children.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final child = childProvider.children[index];
                              return ListTile(
                                leading: Icon(
                                  child.gender == 'Male'
                                      ? Icons.boy
                                      : Icons.girl,
                                  color: child.gender == 'Male'
                                      ? Colors.blue
                                      : Colors.pink,
                                ),
                                title: Text(child.username),
                                subtitle: Text('Age: ${child.age} Year '),
                                trailing: Text(
                                  child.gender == 'Male'
                                      ? 'Male'.tr()
                                      : 'Female'.tr(),
                                  style: AppTextStyles.labelMedium(isDark)
                                      .copyWith(
                                        color: child.gender == 'Male'
                                            ? Colors.blue
                                            : Colors.pink,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headerMedium(
              isDark,
            ).copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            title,
            style: AppTextStyles.labelMedium(isDark).copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _countByGender(List<Child> children, String gender) {
    return children.where((child) => child.gender == gender).length.toString();
  }
}
