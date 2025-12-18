import 'package:baylora_prjct/assets/images.dart';
import 'package:baylora_prjct/constant/app_values_widget.dart';
import 'package:baylora_prjct/screens/auth/widget/auth_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  final _codeCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // --- 1. BACKGROUND ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF7C4DFF), Color(0xFF512DA8)],
              ),
            ),
          ),
          Positioned(
            top: -50, left: -50,
            child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withValues(alpha: 0.1)),
          ),
          Positioned(
            bottom: -80, right: -20,
            child: CircleAvatar(radius: 140, backgroundColor: Colors.white.withValues(alpha: 0.1)),
          ),

          // --- 2. MAIN FORM ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: Text("Need help?", style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(height: 10),
                    
                    // Brand Header
                    Padding(padding:AppValuesWidget.logoPadding, child: SvgPicture.asset(Images.logo) ,),
                    const Text("Baylora", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 25),

                    // Card
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:  0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 5))],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Let's start filling this form", 
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                            ),
                            const SizedBox(height: 20),

                            // --- MODULAR WIDGETS USED HERE ---
                            AuthInputField(label: "First Name", icon: Icons.person, controller: _firstNameCtrl),
                            AuthInputField(label: "Last Name", icon: Icons.person, controller: _lastNameCtrl),
                            AuthInputField(label: "Email", icon: Icons.email, controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
                            
                            AuthInputField(label: "Enter password", icon: Icons.lock, controller: _passCtrl, isPassword: true),
                            AuthInputField(
                              label: "Re-enter password", 
                              icon: Icons.lock, 
                              controller: _confirmPassCtrl, 
                              isPassword: true,
                              validator: (val) {
                                if (val != _passCtrl.text) return "Passwords do not match";
                                return null;
                              },
                            ),

                            // Code & Confirm Button Row
                            Row(
                              children: [
                                Text("Enter Code:", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: TextField(
                                      controller: _codeCtrl,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(border: InputBorder.none, hintText: "00000"),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {}, 
                                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                                  child: const Text("Confirm"),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // Terms Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreeToTerms, 
                                  activeColor: const Color(0xFF512DA8),
                                  onChanged: (v) => setState(() => _agreeToTerms = v!),
                                ),
                                const Expanded(
                                  child: Text("By registering, you agree to our Terms of Service.", style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Register Button
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() && _agreeToTerms) {
                               
                                } else if (!_agreeToTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please accept terms.")));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF512DA8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
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