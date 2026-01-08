import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constant/app_values.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../constant/chat_strings.dart';
import '../provider/chat_provider.dart';

class ChatMessageList extends StatelessWidget {
  final AsyncValue<List<ChatMessage>> messagesAsync;
  final String? currentUserId;

  const ChatMessageList({
    super.key,
    required this.messagesAsync,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return messagesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.royalBlue)),
      error: (err, stack) => Center(child: Text('${ChatStrings.chatLoadingErrorPrefix}$err')),
      data: (messages) {
        if (messages.isEmpty) {
          return _buildEmptyState(context);
        }
        return ListView.builder(
          reverse: true,
          padding: AppValues.paddingLarge,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isMe = msg.senderId == currentUserId;
            return _buildMessageBubble(context, msg, isMe);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppValues.paddingL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppValues.paddingL,
              decoration: BoxDecoration(
                color: AppColors.royalBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded, size: 64, color: AppColors.royalBlue),
            ),
            AppValues.gapM,
            Text(ChatStrings.startConversationTitle, style: AppTextStyles.bodyLarge(context, bold: true)),
            AppValues.gapS,
            Text(ChatStrings.realTimeMessagesSubtitle, style: AppTextStyles.bodyMedium(context, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.royalBlue : AppColors.grey200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Text(
          msg.content,
          style: AppTextStyles.bodyMedium(context, color: isMe ? AppColors.white : AppColors.black),
        ),
      ),
    );
  }
}