import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/root/main_wrapper.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;

  // --- LOGIN LOGIC ---
  Future<void> _login() async {
    setState(() => _isLoading = true);
    
    try {
      // 1. Attempt Login
      final AuthResponse res = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      // Check if screen is still valid after network request
      if (!mounted) return;

      // 2. Success
      if (res.session != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Successful!"),
            backgroundColor: Colors.green,
          ),
        );
        
        // --- FIX FOR ASYNC GAP ---
        // Capture the navigator NOW, while we know context is valid
        final navigator = Navigator.of(context);
        
        // Now wait
        await Future.delayed(const Duration(seconds: 1));

        // Use the CAPTURED 'navigator' variable, not 'context'
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const MainWrapper()), 
        );
      }
      
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unexpected error occurred"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Same Background as Register Page
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.onBoardingBg1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    width: size.width > 500 ? 500 : size.width - 40,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12, // Or AppColors.shadowColor
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- HEADER ---
                          const LogoName(
                            image: Images.logo,
                            fromColor: Color(0xff0049DC),
                            toColor: Color(0xff8F7EFF),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Welcome Back",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 30),

                          // --- INPUTS ---
                          AppTextInput(
                            label: "Email",
                            icon: Icons.email,
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => (val == null || val.isEmpty) ? "Required" : null,
                          ),
                          const SizedBox(height: 15),
                          AppTextInput(
                            label: "Password",
                            icon: Icons.lock,
                            controller: _passCtrl,
                            isPassword: true,
                            validator: (val) => (val == null || val.isEmpty) ? "Required" : null,
                          ),

                          const SizedBox(height: 25),

                          // --- LOGIN BUTTON ---
                          ElevatedButton(
                            
                            onPressed: _isLoading ? null : () {
                              if (_formKey.currentState!.validate()) {
                                _login();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.royalBlue,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: _isLoading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                :  Text("Login",
                                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.primaryColor
                                 ),),
                          ),

                          const SizedBox(height: 20),

                          // --- GO TO REGISTER LINK ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  // Navigate to Register Screen
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const RegisterScreen()), // Rename your other file to RegisterScreen
                                  );
                                },
                                child: const Text("Sign Up"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}