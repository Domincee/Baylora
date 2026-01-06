import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/app_feedback.dart';
import 'package:baylora_prjct/core/util/app_navigation.dart';
import 'package:baylora_prjct/core/util/network_utils.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';
import 'package:baylora_prjct/feature/auth/pages/login.dart';
import 'package:baylora_prjct/feature/auth/services/auth_service.dart';
import 'package:baylora_prjct/feature/auth/widget/register_form.dart';
import 'package:baylora_prjct/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = RegisterFormController();
  final _authService = AuthService(supabase);

  bool _isLoading = false;
  bool _agreeToTerms = false;
  bool _showTermsError = false;

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AuthStrings.termsTitle),
        content: const SingleChildScrollView(
          child: Text(AuthStrings.termsContent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AuthStrings.termsClose),
          ),
        ],
      ),
    );
  }

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
      _form.validate(); // To show inline errors
      AppFeedback.error(context, AuthStrings.fillAllFieldsError);
      return;
    }

    // 2. Validate format (email regex, password length, etc.)
    if (!_form.validate()) {

      AppFeedback.error(context, AuthStrings.invalidInput);
      return; 
    }

    if (_form.passCtrl.text != _form.confirmPassCtrl.text) {
      AppFeedback.error(context, AuthStrings.passwordMismatchError);
      return;
    }

    // 4. Check Terms & Agreement
    if (!_agreeToTerms) {
      setState(() => _showTermsError = true);
      AppFeedback.error(context, AuthStrings.acceptTermsRequired);
      return;
    }

    // Clear terms error if valid
    if (_showTermsError) setState(() => _showTermsError = false);

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
      if (mounted) {
        if (NetworkUtils.isNetworkError(e)) {
           AppFeedback.error(context, AppStrings.noInternetConnection);
        } else {
           AppFeedback.error(context, e.message);
        }
      }
    } catch (e) {
      if (mounted) {
        if (NetworkUtils.isNetworkError(e)) {
           AppFeedback.error(context, AppStrings.noInternetConnection);
        } else {
           AppFeedback.error(context, AuthStrings.unexpectedError);
        }
      }
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
                        agreeToTerms: _agreeToTerms,
                        onAgreeChanged: (val) {
                          setState(() {
                            _agreeToTerms = val;
                            if (val) _showTermsError = false;
                          });
                        },
                        onTermsTap: _showTermsDialog,
                        showTermsError: _showTermsError,
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
