import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/root/main_wrapper.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/app_feedback.dart';
import 'package:baylora_prjct/core/util/app_navigation.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';
import 'package:baylora_prjct/feature/auth/pages/register.dart';
import 'package:baylora_prjct/feature/auth/widget/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = LoginFormController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_form.validate()) {
      AppFeedback.error(context, AuthStrings.fillAllFieldsError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final AuthResponse res = await Supabase.instance.client.auth
          .signInWithPassword(
            email: _form.emailCtrl.text.trim(),
            password: _form.passCtrl.text.trim(),
          );

      if (!mounted) return;

      if (res.session != null) {
        AppFeedback.success(context, "Login Successful!");

        await AppFeedback.showLoading(status: 'Redirecting...');
        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        await AppFeedback.hideLoading();

        if (!mounted) return;

        await AppNavigation.pushReplacement(
          context,
          const MainWrapper(),
          routeType: RouteType.fade,
        );
      }
    } on AuthException catch (e) {
      if (mounted) AppFeedback.error(context, e.message);
    } catch (_) {
      if (mounted) AppFeedback.error(context, AuthStrings.unexpectedError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
      unawaited(AppFeedback.hideLoading());
    }
  }

  void _navigateToRegister() {
    AppNavigation.pushReplacement(
      context,
      const RegisterScreen(),
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
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
              padding: AppValues.paddingScreen,
              child: Column(
                children: [
                  // Help button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AuthStrings.helpText,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  AppValues.gapM,

                  // Login form card
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          width: size.width > AppValues.maxContentWidth
                              ? AppValues.maxContentWidth
                              : size.width - AppValues.spacingXXL,
                          padding: AppValues.paddingLarge,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.95),
                            borderRadius: AppValues.borderRadiusXL,
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const LogoName(
                                image: Images.logo,
                                fromColor: AppColors.royalBlue,
                                toColor: AppColors.logoGradientEnd,
                              ),
                              AppValues.gapXS,
                              LoginForm(
                                form: _form,
                                isLoading: _isLoading,
                                onLogin: _handleLogin,
                                onSignUpTap: _navigateToRegister,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Copyright textz
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppValues.spacing10),
                      child: Text(
                        AuthStrings.copyRightText,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
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
