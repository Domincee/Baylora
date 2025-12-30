import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class AppTextInput extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: Theme.of(context).textTheme.labelSmall,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: Icon(
              widget.icon,
              color: AppColors.deepBlue,
              size: AppValues.iconM,
            ),
            filled: true,
            fillColor: AppColors.bgColor,
            contentPadding: AppValues.paddingSmall,
            border: OutlineInputBorder(
              borderRadius: AppValues.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.shadowColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppValues.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.shadowColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppValues.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.royalBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppValues.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppValues.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
            ),
            suffixIcon: _buildSuffixIcon(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textLblG,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }
    return widget.suffixIcon;
  }
}
