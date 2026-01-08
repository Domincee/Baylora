import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/theme/app_text_style.dart';
import 'package:baylora_prjct/core/widgets/listing_summary_card.dart';
import 'package:baylora_prjct/feature/chat/constant/chat_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../details/provider/item_details_provider.dart';
import '../profile/provider/profile_provider.dart';
import 'provider/chat_provider.dart';

class DealChatScreen extends ConsumerStatefulWidget {
  final String chatTitle;
  final String itemName;
  final String contextId;

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
  bool _isUpdatingStatus = false;

  Future<void> _handleStatusUpdate(String itemId, String newStatus) async {
    setState(() => _isUpdatingStatus = true);
    try {
      await ref.read(chatRepositoryProvider).updateItemStatus(itemId, newStatus);

      // Invalidate providers to refresh UI labels everywhere
      ref.invalidate(chatDealContextProvider(widget.contextId));
      // Assuming you have these providers
      ref.invalidate(itemDetailsProvider(itemId));
      ref.invalidate(myListingsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("${ChatStrings.itemMarkedAsPrefix}${newStatus.toUpperCase()}")),
        );
      }
    } catch (e) {
      debugPrint("${ChatStrings.statusUpdateError}$e");
    } finally {
      if (mounted) setState(() => _isUpdatingStatus = false);
    }
  }

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
      debugPrint("${ChatStrings.sendMessageErrorLog}$e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ChatStrings.sendMessageError)),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.contextId));
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
              style: AppTextStyles.titleSmall(context, bold: true),
            ),
            Text(
              "${ChatStrings.regardingPrefix}${widget.itemName}",
              style: AppTextStyles.bodySmall(context, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 2. Insert ListingSummaryCard
          dealAsync.when(
            data: (data) {
              final item = data[ChatStrings.tableItems];
              if (item == null) return const SizedBox.shrink();

              final String itemStatus =
                  item[ChatStrings.colStatus]?.toString().toLowerCase() ?? '';
              final bool showActions = itemStatus == ChatStrings.statusAccepted;

              return Column(
                children: [
                  Container(
                    color: AppColors.greyLight.withValues(alpha: 0.3),
                    padding: const EdgeInsets.all(AppValues.spacingS),
                    child: ListingSummaryCard(
                      item: item,
                      bottomAction: null,
                    ),
                  ),
                  if (showActions)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppValues.spacingM, 0,
                          AppValues.spacingM, AppValues.spacingS),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isUpdatingStatus
                                  ? null
                                  : () => _handleStatusUpdate(
                                      item[ChatStrings.colId].toString(),
                                      ChatStrings.statusCancelled),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.errorColor,
                                side: const BorderSide(
                                    color: AppColors.errorColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text(ChatStrings.cancelDealButton),
                            ),
                          ),
                          AppValues.gapHM,
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isUpdatingStatus
                                  ? null
                                  : () => _handleStatusUpdate(
                                      item[ChatStrings.colId].toString(),
                                      ChatStrings.statusSold),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.successColor,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: _isUpdatingStatus
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: AppColors.white))
                                  : const Text(ChatStrings.markAsDoneButton),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 1, color: AppColors.greyLight),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(
                minHeight: 2, color: AppColors.royalBlue),
            error: (_, _) => const SizedBox.shrink(),
          ),
          // 3. Chat Area
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.royalBlue)),
              error: (err, stack) =>
                  Center(child: Text('${ChatStrings.chatLoadingErrorPrefix}$err')),
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
                            child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 64,
                                color: AppColors.royalBlue),
                          ),
                          AppValues.gapM,
                          Text(
                            ChatStrings.startConversationTitle,
                            style: AppTextStyles.bodyLarge(context, bold: true),
                          ),
                          AppValues.gapS,
                          Text(
                            ChatStrings.realTimeMessagesSubtitle,
                            style: AppTextStyles.bodyMedium(context, color: AppColors.textGrey),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppValues.spacingM),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: ChatStrings.typeMessageHint,
                          hintStyle: AppTextStyles.bodyMedium(context, color: AppColors.textGrey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
                              child: CircularProgressIndicator(
                                  color: AppColors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.send, color: AppColors.white, size: 18),
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
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.royalBlue : AppColors.grey200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight:
                isMe ? const Radius.circular(0) : const Radius.circular(16),
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
