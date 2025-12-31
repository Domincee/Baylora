import 'package:baylora_prjct/core/util/app_validators.dart';
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';

class RegisterForm extends StatelessWidget {
  final RegisterFormController form;
  final bool isLoading;
  final VoidCallback onRegister;
  final VoidCallback? onLoginTap;

  const RegisterForm({
    super.key,
    required this.form,
    required this.isLoading,
    required this.onRegister,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextInput(
            label: "Username",
            icon: Icons.person,
            controller: form.userNameCtrl,
            validator: AppValidators.lettersOnly,
          ),
          AppTextInput(
            label: "First Name",
            icon: Icons.person,
            controller: form.firstNameCtrl,
            validator: AppValidators.lettersOnly,
          ),
          AppTextInput(
            label: "Last Name",
            icon: Icons.person,
            controller: form.lastNameCtrl,
            validator: AppValidators.lettersOnly,
          ),
          AppTextInput(
            label: "Email",
            icon: Icons.email,
            controller: form.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidators.email,
          ),
          AppTextInput(
            label: "Enter password",
            icon: Icons.lock,
            controller: form.passCtrl,
            isPassword: true,
            validator: AppValidators.password,
          ),
          AppTextInput(
            label: "Re-enter password",
            icon: Icons.lock,
            controller: form.confirmPassCtrl,
            isPassword: true,
            validator: (v) =>
                AppValidators.confirmPassword(v, form.passCtrl.text),
          ),
          AppValues.gapL,
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
                    "Register",
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
                "Already have an account?",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextButton(
                onPressed: onLoginTap,
                child: Text(
                  "Login",
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
