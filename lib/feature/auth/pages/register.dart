import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/constant/data_strings.dart';
import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:baylora_prjct/feature/auth/pages/login.dart';
import 'package:baylora_prjct/feature/auth/widget/navigate_to_login.dart';
import 'package:baylora_prjct/feature/auth/widget/terms_agrement.dart';
import 'package:baylora_prjct/main.dart'; 
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userNameCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _agreeToTerms = false;
  bool _isLoading = false; // To show spinner

  // --- REGISTRATION LOGIC ---
  Future<void> _register() async {
  setState(() => _isLoading = true);

  try {
    // 1. Send data to Supabase
    final AuthResponse res = await supabase.auth.signUp(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      data: {
        'first_name': _firstNameCtrl.text.trim(),
        'last_name': _lastNameCtrl.text.trim(),
        'username': _userNameCtrl.text.trim(), // FIXED: Was _lastNameCtrl
      },
    );

    // Stop if the widget closed during the request
    if (!mounted) return;

    // 2. Success Handling
    if (res.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Successful! Please Login."),
          backgroundColor: Colors.green,
        ),
      );

     

      final navigator = Navigator.of(context);
      
      await Future.delayed(const Duration(seconds: 1));

   
      navigator.pushReplacement(
        _createRoute(const LoginScreen()), 
      );
    }
    
  } on AuthException catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: AppColors.primaryColor
        )), backgroundColor: Colors.green),
      );
    }
    
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Unexpected error occurred", 
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: AppColors.primaryColor
        )), backgroundColor:AppColors.errorColor),
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
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // --- BACKGROUND ---
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // --- TOP HELP ---
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        DataStrings.helpText,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: AppColors.primaryColor.withValues(alpha:  0.5),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppValuesWidget.sizedBoxSize),

                  // --- FORM AREA ---
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          width: size.width > 500 ? 500 : size.width - 40,
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha:  0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 0.5,
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
                                const LogoName(
                                  image: Images.logo,
                                  fromColor: Color(0xff0049DC),
                                  toColor: Color(0xff8F7EFF),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  DataStrings.fillFormText,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: AppColors.royalBlue),
                                ),
                                const SizedBox(height: 20),

                                // --- INPUTS ---
                                    AppTextInput(
                                  label: "Username",
                                  icon: Icons.person,
                                  controller: _userNameCtrl,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return "Required";
                                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val)) return "Letters only";
                                    return null;
                                  },
                                ),
                                AppTextInput(
                                  label: "First Name",
                                  icon: Icons.person,
                                  controller: _firstNameCtrl,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return "Required";
                                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val)) return "Letters only";
                                    return null;
                                  },
                                ),
                                AppTextInput(
                                  label: "Last Name",
                                  icon: Icons.person,
                                  controller: _lastNameCtrl,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return "Required";
                                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val)) return "Letters only";
                                    return null;
                                  },
                                ),
                                AppTextInput(
                                  label: "Email",
                                  icon: Icons.email,
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return "Required";
                                    if (val.startsWith('@')) return "Enter name before @";
                                    if (!val.contains('@') || !val.contains('.')) return "Invalid Email";
                                    return null;
                                  },
                                ),
                                AppTextInput(
                                  label: "Enter password",
                                  icon: Icons.lock,
                                  controller: _passCtrl,
                                  isPassword: true,
                                  validator: (val) => val!.length < 6 ? "Min 6 chars" : null,
                                ),
                                AppTextInput(
                                  label: "Re-enter password",
                                  icon: Icons.lock,
                                  controller: _confirmPassCtrl,
                                  isPassword: true,
                                  validator: (val) => val != _passCtrl.text ? "Mismatch" : null,
                                ),

                                const SizedBox(height: 10),

                                // --- TERMS ---
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 24, width: 24,
                                      child: Checkbox(
                                        value: _agreeToTerms,
                                        activeColor: const Color(0xFF512DA8),
                                        onChanged: (v) => setState(() => _agreeToTerms = v!),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: RichText(text: termsAgrement(context)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppValuesWidget.sizedBoxSize),

                                // --- REGISTER BUTTON ---
                                ElevatedButton(
                                  onPressed: _isLoading ? null : () {
                                    // 1. Validate Form
                                    final bool isFormValid = _formKey.currentState!.validate();
                                    
                                    if (!isFormValid) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Please fill the empty fields"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // 2. Validate Terms
                                    if (!_agreeToTerms) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Please accept terms & agreement"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // 3. SUCCESS -> Call Register Logic
                                    _register();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF512DA8),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: _isLoading
                                    ? const SizedBox(
                                        height: 20, width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text(
                                        "Register",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                ),

                                const SizedBox(height: AppValuesWidget.sizedBoxSize),
                                navigateToLogin(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- FOOTER ---
                  Column(
                    children: [
                      const SizedBox(height: AppValuesWidget.sizedBoxSize),
                      Text("Version 1.0.0", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: AppColors.secondaryColor.withValues(alpha:  0.3))),
                      Text("© 2024 Baylora. All rights reserved", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: AppColors.secondaryColor.withValues(alpha:  0.3))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500), // Adjust speed here
  );
}