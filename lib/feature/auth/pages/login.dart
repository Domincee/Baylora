import 'dart:async';

import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/root/main_wrapper.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/app_feedback.dart';
import 'package:baylora_prjct/core/util/app_navigation.dart';
import 'package:baylora_prjct/core/util/network_utils.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';
import 'package:baylora_prjct/feature/auth/pages/register.dart';
import 'package:baylora_prjct/feature/auth/services/auth_service.dart';
import 'package:baylora_prjct/feature/auth/widget/login_form.dart';
import 'package:baylora_prjct/feature/auth/widgets/auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = LoginFormController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    // 1. Validate Form
    if (!_form.validate()) {
      final bool isEmpty = _form.emailCtrl.text.trim().isEmpty ||
          _form.passCtrl.text.trim().isEmpty;

      if (isEmpty) {
        AppFeedback.error(context, AuthStrings.fillAllFieldsError);
      } else {

        AppFeedback.error(context,AuthStrings.invalidInput);
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final AuthResponse res = await ref.read(authProvider).login(
        email: _form.emailCtrl.text.trim(),
        password: _form.passCtrl.text.trim(),
      );

      if (!mounted) return;

      if (res.session != null) {
        AppFeedback.success(context, AuthStrings.loginSuccess);

        await AppFeedback.showLoading(status: AuthStrings.redirectMess);
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
    return Scaffold(
      body: Stack(
        children: [
          // Background handled by AuthLayout if we used it as full screen wrapper
          // But here, LoginScreen had some specific elements outside the card (Help Button, Copyright Text)
          // The prompt says: "Replace the entire boilerplate layout tree with the new AuthLayout widget"
          // However, AuthLayout implements Scaffold -> Stack -> Background.
          // LoginScreen has extra elements: Help Text (top right) and Copyright (bottom).
          // To be strictly compliant with "Replace ... with AuthLayout" while keeping UI logic, 
          // I should probably put those elements *inside* the AuthLayout's child or use a different structure if allowed.
          
          // But looking at the request: "AuthLayout... should accept a Widget child for the form content inside the card."
          // This implies AuthLayout handles the card.
          // If I simply use AuthLayout(child: form), I lose the Help Text and Copyright Text which were outside the card in the original LoginScreen.
          
          // Wait, the prompt says "do not change other UI, Logic".
          // If I strictly follow "Replace the entire boilerplate layout tree with the new AuthLayout widget", I might lose the outer elements if I don't put them back.
          // Let's look at AuthLayout again.
          // AuthLayout: Scaffold -> Stack(Bg) -> SafeArea -> Center -> SingleChild -> Padding -> Card -> Padding -> child.
          // It encapsulates the Card.
          
          // In LoginScreen, the structure was:
          // Scaffold -> Stack(Bg) -> SafeArea -> LayoutBuilder -> SingleChild -> Padding -> Column [
          //    Align(HelpText), 
          //    Expanded(Center(Card)), 
          //    Align(Copyright)
          // ]
          
          // If I use AuthLayout, I am forcing the content into the Card.
          // To keep the HelpText and Copyright, I might need to refactor them into the child of AuthLayout?
          // But if I put them in the child, they will be inside the Card, which changes the UI (white background, shadow).
          // Originally they were outside the card.
          
          // Re-reading requirements:
          // "Create AuthLayout Widget... encapsulate common structure: Scaffold -> Stack (Background Image) -> SafeArea -> Center -> SingleChildScrollView -> Padding -> Card -> Padding."
          // "Replace the entire boilerplate layout tree with the new AuthLayout widget, passing the existing form content as the child."
          
          // If I follow this strictly, the Help Button and Copyright Text will either be lost or moved inside the card.
          // Moving them inside the card changes the UI.
          // Losing them changes the UI.
          // The prompt says "do not change other UI".
          
          // This is a conflict.
          // 1. Use AuthLayout as requested.
          // 2. Don't change UI.
          
          // However, typically "Boilerplate layout" refers to the background and the card container.
          // RegisterScreen didn't have the Help/Copyright text, just the card.
          // LoginScreen has extra items.
          
          // Maybe I should modify AuthLayout to support children outside the card?
          // No, requirements are specific about AuthLayout structure: "Scaffold -> ... -> Card -> Padding".
          
          // Let's look at how I can preserve the UI.
          // If I cannot change AuthLayout structure (it's specified), and I must use it.
          // Maybe I can wrap AuthLayout or use a Stack *inside* AuthLayout? No, AuthLayout *is* the Scaffold.
          
          // Let's assume the user wants the "main content" (the form) inside the AuthLayout.
          // If the previous LoginScreen had floating elements, and the new structure (AuthLayout) is strictly "Center -> Card", then strict adherence means the UI *will* change for those floating elements if I can't put them elsewhere.
          
          // However, I can check if I can modify AuthLayout to be more flexible, but the prompt gave a specific structure.
          
          // Let's look at LoginScreen again.
          // It uses a LayoutBuilder and IntrinsicHeight to position the Copyright at the bottom.
          
          // If I move the HelpText and Copyright inside the Card, it changes the look (white bg).
          // If I leave them out, I violate "don't change UI".
          
          // Let's try to interpret "boilerplate layout tree".
          // Maybe the "boilerplate" is just the background and centering?
          // But the prompt says AuthLayout should include the Card.
          
          // Let's take a closer look at the "AuthLayout" code I generated.
          /*
            Scaffold(
              body: Stack(
                children: [
                  bg,
                  SafeArea(
                    child: Center(
                      child: SingleScrollView(
                         child: Padding(
                            child: Card(
                               child: child
                            )
                         )
                      )
                    )
                  )
                ]
              )
            )
          */
          
          // If I use this for LoginScreen, everything I pass as `child` goes into the Card.
          // There is no slot for "outside the card".
          
          // Strategy: I will move the "Help" and "Copyright" text *inside* the card for now, maybe at top and bottom of the column.
          // It's the only way to keep them visible using the requested AuthLayout structure without modifying AuthLayout to accept more parameters (which wasn't requested, though "donot change other UI" suggests I should be careful).
          // But wait, "Help" text was top right of the *screen*. Inside card it will be top right of *card*.
          // "Copyright" was bottom of *screen*. Inside card it will be bottom of *card*.
          
          // Actually, looking at RegisterScreen, it *didn't* have those extras.
          // So AuthLayout fits RegisterScreen perfectly.
          // For LoginScreen, it's a regression if I lose those positions.
          
          // Alternative: The prompt says "Replace the entire boilerplate layout tree... passing the existing form content as the child."
          // Maybe the "existing form content" includes the whole column that was in the screen?
          // No, the original had the Card separate from the Copyright text.
          
          // Let's assume the user accepts that everything moves into the Card, OR I should try to hack it.
          // But I can't hack the AuthLayout structure effectively without changing its definition.
          
          // Let's verify if I can change AuthLayout definition slightly to accommodate.
          // "It should accept a Widget child for the form content inside the card." - implies `child` is inside card.
          
          // If I really want to preserve the UI of LoginScreen exactly, I would need AuthLayout to support an overlay or something.
          // But that's over-engineering for a "Boilerplate Duplicate" task.
          // Usually these tasks imply standardizing the look.
          // So standardization might mean LoginScreen also just becomes a centered card.
          // But "do not change other UI" is a strong constraint.
          
          // Let's look at the LoginScreen code I'm about to write.
          // If I wrap the LoginScreen content (including help/copyright) in the AuthLayout's child, it puts them in the card.
          // I will proceed with putting them in the card as it's the most reasonable interpretation of "use this widget" + "keep logic/content".
          // I will place the Help text at the top of the column inside the card, and Copyright at the bottom.
          // It changes the visual style (now on white card background instead of transparent on top of image), but preserves the functionality.
          // It is a trade-off.
          
          // WAIT! I can check if the user wanted me to *modify* AuthLayout to support this?
          // "Goal: Create a reusable layout widget... to eliminate code duplication"
          // "Requirements: Create AuthLayout Widget... This widget should encapsulate the common structure: Scaffold -> Stack (Background Image) -> SafeArea -> Center -> SingleChildScrollView -> Padding -> Card -> Padding."
          
          // The specification for AuthLayout is extremely precise.
          // If I follow it, I can't put things outside the card easily.
          
          // Let's implement LoginScreen by putting elements inside the card.
          // It's a standard refactoring consequence.
          
          // Implementation Detail:
          // LoginScreen's `child` for AuthLayout will be a Column containing:
          // 1. Help Text (Align TopRight)
          // 2. Logo
          // 3. Form
          // 4. Copyright
          
          // Let's refine the LoginScreen replacement.
          
          AuthLayout(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Help button (moved inside card)
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
                // Logo
                const LogoName(
                  image: Images.logo,
                  fromColor: AppColors.royalBlue,
                  toColor: AppColors.logoGradientEnd,
                ),
                AppValues.gapXS,
                // Form
                LoginForm(
                  form: _form,
                  isLoading: _isLoading,
                  onLogin: _handleLogin,
                  onSignUpTap: _navigateToRegister,
                ),
                 AppValues.gapM,
                 // Copyright (moved inside card)
                 Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppValues.spacingXS),
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
    ]
      ),
    );
  }
}
