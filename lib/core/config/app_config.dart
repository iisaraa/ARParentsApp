import 'package:flutter/material.dart';

class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://vwbyhpcygqldhzxshsck.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ3YnlocGN5Z3FsZGh6eHNoc2NrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyMjYwNDYsImV4cCI6MjA4ODgwMjA0Nn0.G4_smWfWgy3I4BNrWrtseCkWfxmdvW7lpfVYZim4gnU';
  static const bool supabaseDebug = true;

  // Localization Configuration
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];
  static const String localizationPath = 'assets/language';
  static const Locale fallbackLocale = Locale('en');
  static const Locale defaultLocale = Locale('en');

  // App Configuration
  static const String appName = 'Arkids World';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const int apiTimeout = 30; // seconds
  static const int maxRetries = 3;

  // Cache Configuration
  static const int cacheExpirationDays = 7;
}