import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'generated/l10n.dart';

final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://vwbyhpcygqldhzxshsck.supabase.co',
      anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ3YnlocGN5Z3FsZGh6eHNoc2NrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyMjYwNDYsImV4cCI6MjA4ODgwMjA0Nn0.G4_smWfWgy3I4BNrWrtseCkWfxmdvW7lpfVYZim4gnU',
      debug: true,
    );
    print('✅ Supabase initialized');

    final result = await Supabase.instance.client
        .from('parent')
        .select()
        .limit(1);
    print('✅ Database connection: ${result.length} records');
  } catch (e) {
    print('❌ Initialization error: $e');
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/language',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const App(),
    ),
  );
}