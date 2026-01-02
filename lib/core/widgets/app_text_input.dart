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
  String? _errorText;
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          validator: (value) {
            // Must return the error string for Form.validate() to work correctly
            if (widget.validator != null) {
              final error = widget.validator!(value);
              // Use Future.microtask/postFrameCallback to avoid setState during build
              final newIsValid = error == null && value != null && value.isNotEmpty;
              
              if (_errorText != error || _isValid != newIsValid) {
                 WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _errorText = error;
                        _isValid = newIsValid;
                      });
                    }
                 });
              }
              return error; 
            }
            return null;
          },
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
            isDense: true,
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
            // Hide the default error text visually but keep validation logic
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            suffixIcon: _buildSuffixIcon(),
          ),
        ),
        AppValues.gapS,
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // Combine password toggle with validation icon if needed
    if (widget.isPassword) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textLblG,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
          _buildValidationIcon(),
        ],
      );
    }
    
    // For non-password fields, append validation icon to existing suffix or use it alone
    if (widget.suffixIcon != null) {
       return Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           widget.suffixIcon!,
           _buildValidationIcon(),
         ],
       );
    }

    return _buildValidationIcon();
  }

  Widget _buildValidationIcon() {
    // Padding for the icon
    const padding = EdgeInsets.only(right: 12.0); 

    if (_errorText != null) {
      return Padding(
        padding: padding,
        child: const Icon(Icons.close, color: AppColors.errorColor),
      );
    } else if (_isValid) {
      return Padding(
        padding: padding,
        child: const Icon(Icons.check, color: AppColors.successColor),
      );
    }
    return const SizedBox.shrink();
  }
}
