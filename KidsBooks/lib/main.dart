import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/supabase_config.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';

/// Application entry point.
///
/// Supabase must be initialized before any database / storage call, so we do it
/// here before [runApp]. Credentials live in [SupabaseConfig].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    // The "publishable" key — older Supabase dashboards label it "anon public".
    publishableKey: SupabaseConfig.supabaseKey,
  );
  runApp(const KidsBooksApp());
}

/// Convenient shortcut to the shared Supabase client used by the services.
final supabase = Supabase.instance.client;

/// Root widget: wires up the global theme and the home route.
class KidsBooksApp extends StatelessWidget {
  const KidsBooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kids' Books",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
