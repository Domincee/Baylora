import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/constant/data_strings.dart';
// Make sure this points to your WIDGET, not just the model
import 'package:baylora_prjct/core/widgets/app_text_input.dart'; 
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.onBoardingBg1),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. MAIN FORM
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                child: Column(
                  children: [
                    // Top Help Button
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          DataStrings.helpText,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.primaryColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),

                    // Brand Header
                    const LogoName(image: Images.logoLight),
                    const SizedBox(height: AppValuesWidget.sizedBoxSize),

                    // FORM CARD
                    Container(
                      
                      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 560),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95), 
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              DataStrings.fillFormText,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: AppColors.royalBlue),
                            ),
                            const SizedBox(height: AppValuesWidget.sizedBoxSize),
                      
                          // 1. FIRST NAME
                              AppTextInput(
                                label: "First Name",
                                icon: Icons.person,
                                controller: _firstNameCtrl,
                           
                                validator: (val) {
                                  if (val == null || val.isEmpty) return "First Name is required";
                                  return null;
                                },
                              ),
                      
                              // 2. LAST NAME
                              AppTextInput(
                                label: "Last Name",
                                icon: Icons.person,
                                controller: _lastNameCtrl,
                                // 👇 ADD THIS
                                validator: (val) {
                                  if (val == null || val.isEmpty) return "Last Name is required";
                                  return null;
                                },
                              ),
                      
                              // 3. EMAIL
                              AppTextInput(
                                label: "Email",
                                icon: Icons.email,
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                // 👇 ADD THIS
                                validator: (val) {
                                  if (val == null || val.isEmpty) return "Email is required";
                                  if (!val.contains('@')) return "Invalid Email"; // Basic check
                                  return null;
                                },
                              ),
                      
                              // 4. PASSWORD
                              AppTextInput(
                                label: "Enter password",
                                icon: Icons.lock,
                                controller: _passCtrl,
                                isPassword: true,
                                // 👇 ADD THIS
                                validator: (val) {
                                  if (val == null || val.isEmpty) return "Password is required";
                                  if (val.length < 6) return "Min 6 characters";
                                  return null;
                                },
                              ),
                      
                              // 5. CONFIRM PASSWORD (You already had this one, keep it!)
                              AppTextInput(
                                label: "Re-enter password",
                                icon: Icons.lock,
                                controller: _confirmPassCtrl,
                                isPassword: true,
                                validator: (val) {
                                  if (val == null || val.isEmpty) return "Confirmation is required";
                                  if (val != _passCtrl.text) return "Passwords do not match";
                                  return null;
                                },
                              ),
                      
                            const SizedBox(height: 10),
                      
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreeToTerms,
                                  activeColor: const Color(0xFF512DA8),
                                  onChanged: (v) => setState(() => _agreeToTerms = v!),
                                ),
                                const Expanded(
                                  child: Text(
                                    "By registering, you agree to our Terms of Service.",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                      
                            const SizedBox(height: 20),
                      
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (!_agreeToTerms) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Please accept terms.")),
                                    );
                                    return;
                                  }
                                  // Proceed
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppValuesWidget.sizedBoxSize + 20,),
                    Text("ASdaSd")
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}