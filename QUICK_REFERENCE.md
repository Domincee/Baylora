# Quick Reference Guide
## New Utilities & Refactored Architecture

---

## 📋 WHAT CHANGED

| What | Where | Why |
|------|-------|-----|
| Error Handling | `core/util/app_feedback.dart` | Unified feedback across app |
| Validation | `core/util/app_validators.dart` | Reusable validators |
| Navigation | `core/util/app_navigation.dart` | Consistent transitions |
| Form State | `feature/auth/controllers/` | Clean page logic |
| Login Form UI | `feature/auth/widget/login_form.dart` | Separated concerns |
| Register Form UI | `feature/auth/widget/register_form.dart` | Extracted from page |

---

## 🔥 QUICK START

### Show Success Message
```dart
AppFeedback.success(context, "Success!");
```

### Show Error Message
```dart
AppFeedback.error(context, "Error occurred");
```

### Show Loading
```dart
await AppFeedback.showLoading(status: 'Loading...');
await AppFeedback.hideLoading();
```

### Validate Email
```dart
validator: AppValidators.validateEmail,
```

### Navigate with Transition
```dart
await AppNavigation.pushReplacement(
  context,
  const NextScreen(),
  routeType: RouteType.fade,
);
```

### Create Form Controller
```dart
final form = LoginFormController();
// or
final form = RegisterFormController();
```

---

## 📂 FILE LOCATIONS

```
NEW CORE UTILITIES:
├── lib/core/util/app_feedback.dart (65 lines)
├── lib/core/util/app_validators.dart (110 lines)
└── lib/core/util/app_navigation.dart (110 lines)

NEW AUTH FEATURE:
├── lib/feature/auth/controllers/auth_form_controller.dart
├── lib/feature/auth/widget/login_form.dart
├── lib/feature/auth/widget/register_form.dart
└── lib/feature/auth/constant/auth_strings.dart

REFACTORED PAGES:
├── lib/feature/auth/pages/login.dart (165 lines, -28%)
└── lib/feature/auth/pages/register.dart (122 lines, -20%)
```

---

## 🎯 MOST COMMON USE CASES

### Case 1: Show Error & Navigate
```dart
try {
  await authService.login(email, password);
  await AppNavigation.pushReplacement(context, MainScreen());
} catch (e) {
  AppFeedback.error(context, e.toString());
}
```

### Case 2: Validate Form & Submit
```dart
if (!form.validate()) {
  AppFeedback.error(context, "Please fill all fields");
  return;
}
await submitForm();
```

### Case 3: Show Loading During Async
```dart
await AppFeedback.showLoading(status: 'Processing...');
await doAsyncTask();
await AppFeedback.hideLoading();
AppFeedback.success(context, "Done!");
```

### Case 4: Create Form Widget
```dart
RegisterForm(
  form: registerFormController,
  isLoading: isLoading,
  agreeToTerms: agreeToTerms,
  onAgreeChanged: (v) => setState(() => agreeToTerms = v),
  onRegister: () => handleRegister(),
  termsText: termsWidget,
)
```

### Case 5: Use Validator
```dart
AppTextInput(
  label: "Email",
  controller: emailController,
  validator: AppValidators.validateEmail,
)
```

---

## ⚡ COMMON PATTERNS

### Pattern: Complete Login Flow
```dart
Future<void> _handleLogin() async {
  // 1. Validate
  if (!_form.validate()) {
    AppFeedback.error(context, "Fill all fields");
    return;
  }

  // 2. Set loading
  setState(() => _isLoading = true);

  try {
    // 3. Call service
    await _authService.login(
      email: _form.emailCtrl.text,
      password: _form.passCtrl.text,
    );

    if (!mounted) return;

    // 4. Show feedback
    AppFeedback.success(context, "Login successful!");

    // 5. Show loading overlay
    await AppFeedback.showLoading(status: 'Redirecting...');
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // 6. Hide loading
    await AppFeedback.hideLoading();

    // 7. Navigate
    if (!mounted) return;
    await AppNavigation.pushReplacement(
      context,
      const MainScreen(),
      routeType: RouteType.fade,
    );
  } catch (e) {
    AppFeedback.error(context, e.toString());
  } finally {
    if (mounted) setState(() => _isLoading = false);
    await AppFeedback.hideLoading();
  }
}
```

---

## 🚨 DEPRECATED (Remove These)

```dart
// ❌ OLD - Don't use
ScaffoldMessenger.of(context).showSnackBar(...)
EasyLoading.show() / EasyLoading.dismiss()
Navigator.of(context).pushReplacement(MaterialPageRoute(...))

// ✅ NEW - Use instead
AppFeedback.success/error/warning/info(context, message)
AppFeedback.showLoading() / AppFeedback.hideLoading()
AppNavigation.pushReplacement(context, page, routeType: RouteType.fade)
```

---

## 📦 WHAT TO DELETE

```bash
# File 1: Redundant widget wrapper
rm lib/feature/auth/widget/input_field_model.dart

# File 2: Empty services folder
rm lib/services/service.dart

# File 3: Deprecated constants (optional, only if nothing else uses it)
rm lib/feature/auth/constant/data_strings.dart
```

---

## 🔗 IMPORT STATEMENTS

```dart
// Feedback
import 'package:baylora_prjct/core/util/app_feedback.dart';

// Validators
import 'package:baylora_prjct/core/util/app_validators.dart';

// Navigation
import 'package:baylora_prjct/core/util/app_navigation.dart';

// Form Controllers
import 'package:baylora_prjct/feature/auth/controllers/auth_form_controller.dart';

// Forms
import 'package:baylora_prjct/feature/auth/widget/login_form.dart';
import 'package:baylora_prjct/feature/auth/widget/register_form.dart';

// Constants
import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';
```

---

## ✅ VALIDATION METHODS

```dart
AppValidators.validateEmail(value)              // Email format
AppValidators.validatePassword(value)           // Password strength
AppValidators.validateUsername(value)           // Username rules
AppValidators.validateName(value)               // Name format
AppValidators.validateRequired(value)           // Required field
AppValidators.validatePasswordMatch(value, pwd) // Password match
```

---

## 🎨 TRANSITION TYPES

```dart
RouteType.fade      // Smooth opacity transition
RouteType.slide     // Slide in from right
RouteType.scale     // Scale up from center
RouteType.material  // Standard material transition
```

---

## 📊 CODE REDUCTION

```
login.dart:     251 lines → 165 lines (-35%)
register.dart:  149 lines → 122 lines (-18%)
Total:          400 lines → 287 lines (-28%)

Plus new utilities: 285 lines (but reusable across app)
Net improvement: Cleaner, more maintainable code
```

---

## 🔄 MIGRATION CHECKLIST

**Step 1: Delete Deprecated Files**
```bash
rm lib/feature/auth/widget/input_field_model.dart
rm lib/services/service.dart
```

**Step 2: Run Analysis**
```bash
flutter analyze
```

**Step 3: Fix Any Imports**
- Search for imports of deleted files
- Update to use new utilities

**Step 4: Test**
```bash
flutter test
flutter run
```

**Step 5: Verify Flows**
- [ ] Login works
- [ ] Register works
- [ ] Errors display correctly
- [ ] Navigation transitions work
- [ ] Validations work

---

## 💡 PRO TIPS

1. **Extend Validators**
   - Create feature-specific validators if needed
   - Keep them in `core/util` for reusability

2. **Custom Feedback Styles**
   - Edit `app_feedback.dart` to adjust colors/styles
   - All screens automatically inherit changes

3. **Add More Transitions**
   - Edit `app_navigation.dart` to add new transition types
   - Add to `RouteType` enum

4. **Reuse Form Controllers**
   - Extend `AuthFormController` for new forms
   - Share common fields between forms

5. **String Constants**
   - Keep auth strings in `auth_strings.dart`
   - Create similar files for other features

---

## 🆘 TROUBLESHOOTING

**Issue**: Import not found
```
Solution: Check file path and ensure new files exist
```

**Issue**: Validator not working
```
Solution: Make sure you pass the validator function, not call it
❌ validator: AppValidators.validateEmail()
✅ validator: AppValidators.validateEmail
```

**Issue**: Navigation not working
```
Solution: Check mounted state and use async/await properly
```

**Issue**: Loading doesn't hide
```
Solution: Call AppFeedback.hideLoading() in finally block
```

---

## 📚 RELATED FILES

- `AUDIT_REPORT.md` - Full audit findings
- `REFACTORING_GUIDE.md` - Detailed implementation guide
- `ARCHITECTURE_SUMMARY.md` - High-level overview

---

**Last Updated**: 2025-12-30
**Version**: 1.0
**Status**: Ready for use
