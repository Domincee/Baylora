import 'package:baylora_prjct/core/config/routes.dart';
import 'package:baylora_prjct/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black 
    ..userInteractions = false;
}

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
  // Wrap the app with ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

//  access to Supabase 
final supabase = Supabase.instance.client;


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: AppTheme.themeData,
      
      debugShowCheckedModeBanner: false,
     
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      builder: EasyLoading.init(),
    );
  }

}
