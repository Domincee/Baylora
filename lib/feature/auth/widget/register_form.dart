import 'package:baylora_prjct/core/util/app_validators.dart';
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';
import 'package:baylora_prjct/feature/auth/widget/auth_checkbox.dart';

class RegisterForm extends StatelessWidget {
  final RegisterFormController form;
  final bool isLoading;
  final VoidCallback onRegister;
  final VoidCallback? onLoginTap;
  final bool agreeToTerms;
  final ValueChanged<bool> onAgreeChanged;
  final VoidCallback onTermsTap;
  final bool showTermsError;

  const RegisterForm({
    super.key,
    required this.form,
    required this.isLoading,
    required this.onRegister,
    this.onLoginTap,
    required this.agreeToTerms,
    required this.onAgreeChanged,
    required this.onTermsTap,
    this.showTermsError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextInput(
            label: AuthStrings.usernameLabel,
            icon: Icons.person,
            controller: form.userNameCtrl,
            validator: AppValidators.validateUsername,
          ),
          AppTextInput(
            label: AuthStrings.firstNameLabel,
            icon: Icons.person,
            controller: form.firstNameCtrl,
            validator: AppValidators.validateName,
          ),
          AppTextInput(
            label: AuthStrings.lastNameLabel,
            icon: Icons.person,
            controller: form.lastNameCtrl,
            validator: AppValidators.validateName,
          ),
          AppTextInput(
            label: AuthStrings.emailLabel,
            icon: Icons.email,
            controller: form.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidators.email,
          ),
          AppTextInput(
            label: AuthStrings.passwordLabel,
            icon: Icons.lock,
            controller: form.passCtrl,
            isPassword: true,
            validator: AppValidators.password,
          ),
          AppTextInput(
            label: AuthStrings.confirmPasswordLabel,
            icon: Icons.lock,
            controller: form.confirmPassCtrl,
            isPassword: true,
            validator: (v) =>
                AppValidators.confirmPassword(v, form.passCtrl.text),
          ),
          
          // Reusable Auth Checkbox for Terms
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AuthCheckbox(
              label: AuthStrings.iAgreeTo,
              value: agreeToTerms,
              onChanged: (v) => onAgreeChanged(v ?? false),
              showError: showTermsError,
              onLabelTap: onTermsTap,
              linkText: AuthStrings.openTermsDialogText,
            ),
          ),

          AppValues.gapM,
          
          ElevatedButton(
            onPressed: isLoading ? null : onRegister,
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  )
                : Text(
                    AuthStrings.signUpText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                  ),
          ),
          AppValues.gapM,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AuthStrings.haveAccountText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextButton(
                onPressed: onLoginTap,
                child: Text(
                  AuthStrings.loginText,
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
