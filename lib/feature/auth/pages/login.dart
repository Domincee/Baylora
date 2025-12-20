import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/root/main_wrapper.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
      //Network Request
      final AuthResponse res = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

    
      if (!mounted) return;

      if (res.session != null) {
        // Show Success SnackBar 
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text("Login Successful!", 
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.primaryColor),),
            backgroundColor: AppColors.sucessColor,
          ),
        );

        // Show Loading Overlay
        await EasyLoading.show(status: 'Redirecting...');

        // ignore: use_build_context_synchronously
        final navigator = Navigator.of(context);

        //Wait
        await Future.delayed(const Duration(seconds: 1));

        // Dismiss Loader
        await EasyLoading.dismiss();

       
        navigator.pushReplacement(
           MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      }

    } on AuthException catch (e) {
     
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.errorColor),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unexpected error occurred"), backgroundColor: AppColors.errorColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
      EasyLoading.dismiss();
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
     
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