import 'package:flutter/material.dart';
import '../../../core/constant/app_values.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../constant/chat_strings.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.spacingM),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
        Expanded(
        child: TextField(
        controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: ChatStrings.typeMessageHint,
            hintStyle: AppTextStyles.bodyMedium(context, color: AppColors.textGrey),

            filled: true,
            fillColor: AppColors.greyLight,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),

            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onSubmitted: (_) => onSend(),
        ),
      ),


            AppValues.gapHS,
            CircleAvatar(
              backgroundColor: AppColors.royalBlue,
              child: IconButton(
                icon: isSending
                    ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                )
                    : const Icon(Icons.send, color: AppColors.white, size: 18),
                onPressed: isSending ? null : onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}