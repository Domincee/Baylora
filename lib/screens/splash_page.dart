import 'package:baylora_prjct/main.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }
Future<void> _redirect() async {
     /* waits 200 milliseconds */
    await Future.delayed(const Duration(milliseconds: 200));
    final session = supabase.auth.currentSession;

    /* Destroy if screen is closed*/
    if (!mounted) return; 
   
   /* check if already login */
    if (session != null) {
      /* already login */
      Navigator.pushReplacementNamed(context, '/map'); 
    } else {
      /* not login */
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), 
    );
  }
}