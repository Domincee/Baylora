import 'package:baylora_prjct/config/routes.dart';
import 'package:baylora_prjct/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await dotenv.load(fileName: ".env");

  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
    );
    debugPrint("Supabase Initialized");
  } catch (e) {
    debugPrint("Supabase Initialization Failed: $e");
  }

  runApp(const MyApp());
}

// Shortcut to access Supabase anywhere in your app
final supabase = Supabase.instance.client;


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: AppTheme.themeData,
      
      debugShowCheckedModeBanner: false,
     
      initialRoute: AppRoutes.onboarding,
      routes: AppRoutes.routes,
    );
  }

}
