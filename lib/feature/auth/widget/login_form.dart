import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/app_validators.dart';
import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';
import 'package:baylora_prjct/feature/auth/widget/auth_checkbox.dart';

/// Login form widget with email and password inputs
class LoginForm extends StatefulWidget {
  final LoginFormController form;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback? onSignUpTap;

  const LoginForm({
    super.key,
    required this.form,
    required this.isLoading,
    required this.onLogin,
    this.onSignUpTap,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Local state for "Remember Me"
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.form.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Heading
          Text(
            AuthStrings.loginTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          AppValues.gapL,

          // Email input
          AppTextInput(
            label: AuthStrings.emailLabel,
            icon: Icons.email,
            controller: widget.form.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidators.email,
          ),

          // Password input
          AppTextInput(
            label: AuthStrings.passwordLabel,
            icon: Icons.lock,
            controller: widget.form.passCtrl,
            isPassword: true,
            validator: AppValidators.password,
          ),

          // Remember Me Checkbox (Using Reusable AuthCheckbox)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AuthCheckbox(
              label: "Remember Me",
              value: _rememberMe,
              onChanged: (val) {
                setState(() {
                  _rememberMe = val ?? false;
                });
              },
            ),
          ),

          AppValues.gapL,

          // Login button
          ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.royalBlue,
              padding: const EdgeInsets.symmetric(vertical: AppValues.spacingM),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  )
                : Text(
                    AuthStrings.loginText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
          ),

          AppValues.gapM,

          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AuthStrings.noAccountText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextButton(
                onPressed: widget.onSignUpTap,
                child: Text(
                  AuthStrings.signUpText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.highLightTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
