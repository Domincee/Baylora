import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/app_validators.dart';
import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';

/// Login form widget with email and password inputs
class LoginForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Form(
      key: form.formKey,
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
            controller: form.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidators.validateEmail,
          ),

          // Password input
          AppTextInput(
            label: AuthStrings.passwordLabel,
            icon: Icons.lock,
            controller: form.passCtrl,
            isPassword: true,
            validator: AppValidators.validatePassword,
          ),

          AppValues.gapL,

          // Login button
          ElevatedButton(
            onPressed: isLoading ? null : onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.royalBlue,
              padding: const EdgeInsets.symmetric(vertical: AppValues.spacingM),
            ),
            child: isLoading
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
                onPressed: onSignUpTap,
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
