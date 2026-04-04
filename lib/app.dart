import 'package:ARKidsWorld/app/providers/app_provider.dart';
import 'package:ARKidsWorld/app/providers/auth_provider.dart';
import 'package:ARKidsWorld/app/providers/child_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/pages/home_page.dart';
import 'app/pages/profile_page.dart';
import 'app/pages/reports_page.dart';
import 'app/pages/settings_page.dart';
import 'app/pages/welcome_page.dart';
import 'core/themes/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChildProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ARKids World'.tr(),
            locale: appProvider.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: context.localizationDelegates,
            theme: AppTheme.getLightTheme(),
            darkTheme: AppTheme.getDarkTheme(),
            themeMode: appProvider.themeMode,
            home: const AuthGate(),
            routes: {
              '/profile': (context) => const ProfilePage(),
              '/reports': (context) => const ReportsPage(),
              '/settings': (context) => const SettingsPage(),
              '/home': (context) => const HomePage(),
            },
          );
        },
      ),
    );
  }
}
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {

        if (session != null) {
          return const HomePage();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const WelcomePage();
      },
    );
  }
}