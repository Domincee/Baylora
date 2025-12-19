import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/config/routes.dart';
import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/constant/data_strings.dart';
import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,

      resizeToAvoidBottomInset: false, 
      body: Stack(
        children: [
          // --- 1. BACKGROUND IMAGE ---
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
                  // --- TOP: Help Button ---
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        DataStrings.helpText,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.primaryColor.withValues( alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                      const SizedBox(height: AppValuesWidget.sizedBoxSize),

                  // --- MIDDLE:  ---
                  Expanded(
                    child: Center(
              
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                   
                          width: size.width > 500 ? 500 : size.width - 40, 
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues( alpha: 0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: AppValuesWidget.borderRadius,
                                offset: Offset(0, 5),
                              )
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Hug content
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header
                                const LogoName(image: Images.logo, fromColor: Color(0xff0049DC), toColor:Color(0xff8F7EFF) ,),
                                const SizedBox(height: 10),
                                Text( 
                                  DataStrings.fillFormText,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: AppColors.royalBlue,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Inputs
                                AppTextInput(
                                  label: "First Name",
                                  icon: Icons.person,
                                  controller: _firstNameCtrl,
                                  validator: (val) => val!.isEmpty ? "Required" : null,
                                ),
                                AppTextInput(
                                  label: "Last Name",
                                  icon: Icons.person,
                                  controller: _lastNameCtrl,
                                  validator: (val) => val!.isEmpty ? "Required" : null,
                                ),
                                AppTextInput(
                                  label: "Email",
                                  icon: Icons.email,
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) => !val!.contains('@') ? "Invalid Email" : null,
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
                                  validator: (val) {
                                    if (val != _passCtrl.text) return "Mismatch";
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 10),

                                // Terms Checkbox
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
                                                                              child:  RichText(
                                          text: TextSpan(
                                            text: "By registering, you agree to our ",
                                            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                                            children: [
                                              TextSpan(
                                                text: "Terms & Agreements",
                                                style: const TextStyle(
                                                  color: AppColors.highLightTextColor, // highlighted color
                                                  fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration.underline, // optional
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    // Show modal
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text("Terms & Agreements"),
                                                          content: const SingleChildScrollView(
                                                            child: Text(
                                                              "Here are the full terms & agreements...",
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              child: const Text("Done"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppValuesWidget.sizedBoxSize),
                    
                                // Register Button
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate() && _agreeToTerms) {
                                      // Proceed
                                    } else if (!_agreeToTerms) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Please accept terms.")),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF512DA8),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),

                                                             const SizedBox(height: AppValuesWidget.sizedBoxSize),

                        
                          RichText(
                              text: TextSpan(
                                
                                text: "Already Have Account? ",
                                style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                                children: [
                                  
                                  TextSpan(
                                    text: "Login",
                                    style: const TextStyle(
                                      color: AppColors.highLightTextColor, 
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, AppRoutes.createListing);

                                      },
                                  ),
                                ],
                              ),
                            ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                  ),

                  // --- BOTTOM: Footer Info ---
                  Column(
                    children: [
                      const SizedBox(height: AppValuesWidget.sizedBoxSize),
                      Text(
                        "Version 1.0.0",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.secondaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      Text(
                        "© 2024 Baylora. All rights reserved",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                         color: AppColors.secondaryColor.withValues(alpha: 0.3),

                        ),
                      ),
                       
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