import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constant/chat_strings.dart';
import '../provider/chat_provider.dart';
import '../../details/provider/item_details_provider.dart';
import '../../profile/provider/profile_provider.dart';

mixin ChatActionsMixin {
  Future<void> handleStatusUpdate({
    required BuildContext context,
    required WidgetRef ref,
    required String itemId,
    required String newStatus,
    required String contextId,
    required Function(bool) setUpdating,
  }) async {
    setUpdating(true);
    try {
      await ref.read(chatRepositoryProvider).updateItemStatus(itemId, newStatus);

      ref.invalidate(chatDealContextProvider(contextId));
      ref.invalidate(itemDetailsProvider(itemId));
      ref.invalidate(myListingsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${ChatStrings.itemMarkedAsPrefix}${newStatus.toUpperCase()}")),
        );
      }
    } catch (e) {
      debugPrint("${ChatStrings.statusUpdateError}$e");
    } finally {
      setUpdating(false);
    }
  }

  Future<void> sendMessage({
    required BuildContext context,
    required WidgetRef ref,
    required String contextId,
    required TextEditingController controller,
    required Function(bool) setSending,
  }) async {
    final content = controller.text.trim();
    if (content.isEmpty) return;

    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;

    setSending(true);
    controller.clear();

    try {
      await ref.read(chatRepositoryProvider).sendMessage(
        contextId,
        content,
        currentUser.id,
      );
    } catch (e) {
      debugPrint("${ChatStrings.sendMessageErrorLog}$e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(ChatStrings.sendMessageError)),
        );
      }
    } finally {
      setSending(false);
    }
  }
}