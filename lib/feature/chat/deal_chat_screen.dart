import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/listing_summary_card.dart'; // Import the new card
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'provider/chat_provider.dart';

class DealChatScreen extends ConsumerStatefulWidget {
  final String chatTitle;
  final String itemName;
  final String contextId; // This is the offerId

  const DealChatScreen({
    super.key,
    required this.chatTitle,
    required this.itemName,
    required this.contextId,
  });

  @override
  ConsumerState<DealChatScreen> createState() => _DealChatScreenState();
}

class _DealChatScreenState extends ConsumerState<DealChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;

    setState(() => _isSending = true);

    _messageController.clear();

    try {
      await ref.read(chatRepositoryProvider).sendMessage(
        widget.contextId,
        content,
        currentUser.id,
      );
    } catch (e) {
      debugPrint("Error sending message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send message")),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.contextId));
    // 1. Watch the deal context to get item details
    final dealAsync = ref.watch(chatDealContextProvider(widget.contextId));

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        shadowColor: AppColors.shadowColor.withValues(alpha: 0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chatTitle,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            // We can remove the subtitle here since we have the card,
            // or keep it as a fallback.
            Text(
              "Regarding: ${widget.itemName}",
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 2. Insert ListingSummaryCard
          dealAsync.when(
            data: (data) {
              // The provider returns the OFFER object, which contains the 'items' object
              final item = data['items'];
              if (item == null) return const SizedBox.shrink();

              return Container(
                color: AppColors.greyLight.withValues(alpha: 0.3),
                padding: const EdgeInsets.all(AppValues.spacingS),
                child: ListingSummaryCard(
                  item: item,
                  bottomAction: null, // No buttons in chat view
                ),
              );
            },
            loading: () => const LinearProgressIndicator(minHeight: 2, color: AppColors.royalBlue),
            error: (_, _) => const SizedBox.shrink(), // Hide header on error to keep chat usable
          ),

          // 3. Chat Area
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.royalBlue)),
              error: (err, stack) => Center(child: Text('Error loading chat: $err')),
              data: (messages) {
                if (messages.isEmpty) {
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
                            child: const Icon(Icons.chat_bubble_outline_rounded,
                                size: 64, color: AppColors.royalBlue),
                          ),
                          AppValues.gapM,
                          const Text(
                            "Start the Conversation",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black),
                          ),
                          AppValues.gapS,
                          const Text(
                            "Messages will appear in real-time.",
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: AppValues.paddingLarge,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUserId;
                    return _buildMessageBubble(msg, isMe);
                  },
                );
              },
            ),
          ),

          // 4. Input Area (Unchanged)
          Container(
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingM),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: AppColors.textGrey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  AppValues.gapHS,
                  CircleAvatar(
                    backgroundColor: AppColors.royalBlue,
                    child: IconButton(
                      icon: _isSending
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: _isSending ? null : _sendMessage,
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

  Widget _buildMessageBubble(ChatMessage msg, bool isMe) {
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
          style: TextStyle(
            color: isMe ? Colors.white : AppColors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
