import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_gradients.dart';
import '../../core/themes/app_text_styles.dart';
import '../providers/app_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionTitle('appearance'.tr(), isDark),
            const SizedBox(height: 10),

            _buildSettingsCard(
              isDark: isDark,
              children: [
                _buildSettingsTileWithSwitch(
                  icon: Icons.dark_mode,
                  title: 'dark_mode'.tr(),
                  value: appProvider.themeMode == ThemeMode.dark,
                  onChanged: (_) => appProvider.toggleTheme(),
                  isDark: isDark,
                ),
                const Divider(color: Colors.white24, height: 1),
                _buildSettingsTileWithTrailing(
                  icon: Icons.language,
                  title: 'language'.tr(),
                  subtitle: appProvider.locale.languageCode == 'ar' ? 'العربية' : 'English',
                  onTap: () => _showLanguageDialog(context),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('support'.tr(), isDark),
            const SizedBox(height: 10),

            _buildSettingsCard(
              isDark: isDark,
              children: [
                _buildSettingsTileWithTrailing(
                  icon: Icons.contact_support,
                  title: 'contact_us'.tr(),
                  subtitle: 'support@arkidsworld.com',
                  onTap: () => _sendEmail(context),
                  isDark: isDark,
                ),
                const Divider(color: Colors.white24, height: 1),
                _buildSettingsTileWithTrailing(
                  icon: Icons.share,
                  title: 'share_app'.tr(),
                  subtitle: 'share_app_description'.tr(),
                  onTap: () => _shareApp(context),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('about'.tr(), isDark),
            const SizedBox(height: 10),

            _buildSettingsCard(
              isDark: isDark,
              children: [
                _buildSettingsTileWithTrailing(
                  icon: Icons.info,
                  title: 'about_app'.tr(),
                  subtitle: 'version'.tr(args: ['1.0.0']),
                  onTap: () => _showAboutDialog(context),
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTextStyles.labelLarge(isDark).copyWith(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.glassGradient(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: children,
        ),
      ),
    );
  }
  Widget _buildSettingsTileWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium(isDark).copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTileWithTrailing({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium(isDark).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall(isDark).copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final currentLocale = appProvider.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'select_language'.tr(),
          style: AppTextStyles.headerSmall(isDark).copyWith(
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'English',
                style: AppTextStyles.bodyMedium(isDark),
              ),
              trailing: currentLocale.languageCode == 'en'
                  ? Icon(Icons.check_circle, color: AppColors.successLight)
                  : null,
              onTap: () async {
                await appProvider.changeLanguage(const Locale('en'), context);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              title: Text(
                'العربية',
                style: AppTextStyles.bodyMedium(isDark),
              ),
              trailing: currentLocale.languageCode == 'ar'
                  ? Icon(Icons.check_circle, color: AppColors.successLight)
                  : null,
              onTap: () async {
                await appProvider.changeLanguage(const Locale('ar'), context);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'close'.tr(),
              style: AppTextStyles.labelMedium(isDark),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'about_app'.tr(),
          style: AppTextStyles.headerSmall(isDark),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.family_restroom,
              size: 60,
              color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'about_description'.tr(),
              style: AppTextStyles.bodyMedium(isDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'close'.tr(),
              style: AppTextStyles.labelMedium(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareApp(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'share feature coming soon'.tr(),
          style: AppTextStyles.bodySmall(isDark),
        ),
        backgroundColor: AppColors.successLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _sendEmail(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@arkidsworld.com',
      query: 'subject=Support Request&body=Hello, I need help with...',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'coming soon ...'.tr(),
                style: AppTextStyles.bodySmall(isDark),
              ),
              backgroundColor: AppColors.warningDark,
            ),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'no email app'.tr(),
              style: AppTextStyles.bodySmall(isDark),
            ),
            backgroundColor: AppColors.warningLight,
          ),
        );
      }
    }
  }
}