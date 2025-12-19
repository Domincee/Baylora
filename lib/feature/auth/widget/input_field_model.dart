import 'package:baylora_prjct/core/widgets/app_text_input.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.txtControl,
    required this.text,
    this.icon = Icons.person,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController txtControl;
  final String text;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; 

  @override
  Widget build(BuildContext context) {
    return AppTextInput(
      label: text,
      icon: icon,
      
      controller: txtControl,
      isPassword: isPassword,
      keyboardType: keyboardType,
      validator: validator, 
    );
  }
}
