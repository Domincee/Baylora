import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../constant/chat_strings.dart';
import '../provider/chat_provider.dart';
import '../mixins/chat_actions_mixin.dart';
import '../widgets/chat_deal_header.dart';
import '../widgets/chat_message_list.dart'; // Create similar to previous list logic
import '../widgets/chat_input_field.dart';   // Create similar to previous input logic

class DealChatScreen extends ConsumerStatefulWidget {
  final String chatTitle;
  final String itemName;
  final String contextId;

  const DealChatScreen({super.key, required this.chatTitle, required this.itemName, required this.contextId});

  @override
  ConsumerState<DealChatScreen> createState() => _DealChatScreenState();
}

class _DealChatScreenState extends ConsumerState<DealChatScreen> with ChatActionsMixin {
  final TextEditingController _messageController = TextEditingController();
  bool _isUpdatingStatus = false;
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatTitle, style: AppTextStyles.titleSmall(context, bold: true)),
            Text("${ChatStrings.regardingPrefix}${widget.itemName}", style: AppTextStyles.bodySmall(context, color: AppColors.textGrey)),
          ],
        ),
      ),
      body: Column(
        children: [
          dealAsync.when(
            data: (data) => ChatDealHeader(
              item: data[ChatStrings.tableItems],
              isUpdating: _isUpdatingStatus,
              onCancel: () => handleStatusUpdate(
                context: context, ref: ref, contextId: widget.contextId,
                itemId: data[ChatStrings.tableItems][ChatStrings.colId].toString(),
                newStatus: ChatStrings.statusCancelled,
                setUpdating: (v) => setState(() => _isUpdatingStatus = v),
              ),
              onDone: () => handleStatusUpdate(
                context: context, ref: ref, contextId: widget.contextId,
                itemId: data[ChatStrings.tableItems][ChatStrings.colId].toString(),
                newStatus: ChatStrings.statusSold,
                setUpdating: (v) => setState(() => _isUpdatingStatus = v),
              ),
            ),
            loading: () => const LinearProgressIndicator(minHeight: 2, color: AppColors.royalBlue),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Expanded(
            child: ChatMessageList(messagesAsync: messagesAsync, currentUserId: currentUserId),
          ),
          ChatInputField(
            controller: _messageController,
            isSending: _isSending,
            onSend: () => sendMessage(
              context: context, ref: ref, contextId: widget.contextId,
              controller: _messageController,
              setSending: (v) => setState(() => _isSending = v),
            ),
          ),
        ],
      ),
    );
  }
}