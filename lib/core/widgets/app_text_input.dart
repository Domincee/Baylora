import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class AppTextInput extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  // Added suffixIcon to constructor since it was referenced in your code
  final Widget? suffixIcon; 

  const AppTextInput({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      initialValue: widget.controller.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        
        final bool hasError = state.hasError;
        final String? errorText = state.errorText;
       
        final bool hasText = widget.controller.text.isNotEmpty; 

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(AppValuesWidget.borderRadius),
                border: Border.all(
                  color: hasError ? AppColors.errorColor : AppColors.shadowColor,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                obscureText: widget.isPassword ? _obscureText : false,
                keyboardType: widget.keyboardType,
                style: Theme.of(context).textTheme.labelSmall,
                onChanged: (val) {
                  state.didChange(val);
                  
                  setState(() {}); 
                },
                decoration: InputDecoration(
                  labelText: hasError ? errorText : widget.label,
                  labelStyle: hasError
                      ? Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.errorColor,
                          )
                      : Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.subTextColor,
                          ),
                  prefixIcon: Icon(
                    widget.icon,
                    color: AppColors.deepBlue,
                    size: AppValuesWidget.iconDefaultSize,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  
                
                  suffixIcon: _buildSuffixIcon(hasError, hasText),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget? _buildSuffixIcon(bool hasError, bool hasText) {
  
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textLblG,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }

 
    if (hasError) {
      return const Icon(
        Icons.error_outline,
        color: AppColors.errorColor,
      );
    }

  

    if (hasText) {
      return const Icon(
        Icons.check_circle,
        color: AppColors.sucessColor,
      );
    }


    return widget.suffixIcon;
  }
}