// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_back => 'Welcome Back';

  @override
  String get sign_in_to_continue => 'Sign in to continue';

  @override
  String get login => 'Login';

  @override
  String get login_success => 'Login successful!';

  @override
  String get dont_have_account => 'Don\'t have an account?';

  @override
  String get create_account => 'Create Account';

  @override
  String get already_have_account => 'Already have an account?';

  @override
  String get full_name => 'Full Name';

  @override
  String get full_name_required => 'Please enter your full name';

  @override
  String get email => 'Email';

  @override
  String get email_required => 'Please enter your email';

  @override
  String get email_invalid => 'Please enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get password_required => 'Please enter your password';

  @override
  String get password_min_length => 'Password must be at least 6 characters';

  @override
  String get account_created_successfully => 'Account created successfully!';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get contact_us => 'Contact Us';

  @override
  String get about => 'About';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get support_email => 'support@arkidsworld.com';
}
