import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/app_feedback.dart';
import 'package:baylora_prjct/core/util/app_navigation.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';
import 'package:baylora_prjct/feature/auth/pages/login.dart';
import 'package:baylora_prjct/feature/auth/services/auth_service.dart';
import 'package:baylora_prjct/feature/auth/widget/register_form.dart';
import 'package:baylora_prjct/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = RegisterFormController();
  final _authService = AuthService(supabase);

  bool _isLoading = false;

  Future<void> _handleRegister() async {
    // 1. Check for empty fields first
    final bool hasEmptyFields = 
        _form.userNameCtrl.text.trim().isEmpty ||
        _form.firstNameCtrl.text.trim().isEmpty ||
        _form.lastNameCtrl.text.trim().isEmpty ||
        _form.emailCtrl.text.trim().isEmpty ||
        _form.passCtrl.text.trim().isEmpty ||
        _form.confirmPassCtrl.text.trim().isEmpty;

    if (hasEmptyFields) {
      // Trigger validation to show visual errors on fields
      _form.validate();
      AppFeedback.error(context, AuthStrings.fillAllFieldsError);
      return;
    }

    // 2. Check for password mismatch
    if (_form.passCtrl.text != _form.confirmPassCtrl.text) {
      // Trigger validation to show visual errors on fields
      _form.validate();
      AppFeedback.error(context, AuthStrings.passwordMismatchError);
      return;
    }

    // 3. Final validation check (email format etc.)
    if (!_form.validate()) {
      // Generic error fallback or specific field error
      // Ideally validator messages handle this, but for snackbar:
      // We already handled empty and password match.
      // If it fails here, it's likely email format or other specific rule.
      // But user requested: "Do NOT show 'empty field' error when no field is empty"
      // Since we checked empty fields manually above, we are safe.
      return; 
    }

    setState(() => _isLoading = true);

    try {
      await _authService.register(
        email: _form.emailCtrl.text.trim(),
        password: _form.passCtrl.text.trim(),
        username: _form.userNameCtrl.text.trim(),
        firstName: _form.firstNameCtrl.text.trim(),
        lastName: _form.lastNameCtrl.text.trim(),
      );

      if (!mounted) return;

      AppFeedback.success(context, AuthStrings.registrationSuccess);

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      await AppNavigation.pushReplacement(
        context,
        const LoginScreen(),
        routeType: RouteType.fade,
      );
    } on AuthException catch (e) {
      if (mounted) AppFeedback.error(context, e.message);
    } catch (_) {
      if (mounted) AppFeedback.error(context, AuthStrings.unexpectedError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToLogin() {
    AppNavigation.pushReplacement(
      context,
      const LoginScreen(),
      routeType: RouteType.fade,
    );
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Images.onBoardingBg1,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: AppValues.paddingScreen,
                child: Container(
                  padding: AppValues.paddingLarge,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.95),
                    borderRadius: AppValues.borderRadiusXL,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LogoName(
                        image: Images.logo,
                        fromColor: AppColors.royalBlue,
                        toColor: AppColors.logoGradientEnd,
                      ),
                      AppValues.gap20,
                      RegisterForm(
                        form: _form,
                        isLoading: _isLoading,
                        onRegister: _handleRegister,
                        onLoginTap: _navigateToLogin,
                      ),
                    ],
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
