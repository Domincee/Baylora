import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatMessage {
  final String id;
  final String content;
  final String senderId;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      senderId: json['sender_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  Future<void> sendMessage(String offerId, String content, String senderId) async {
    await _client.from('messages').insert({
      'offer_id': offerId,
      'sender_id': senderId,
      'content': content,
    });
  }

  Stream<List<ChatMessage>> getMessages(String offerId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('offer_id', offerId)
        .order('created_at', ascending: false) // Newest first for reverse list
        .map((data) => data.map((e) => ChatMessage.fromJson(e)).toList());
  }
}

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(Supabase.instance.client);
});

final chatMessagesProvider = StreamProvider.family.autoDispose<List<ChatMessage>, String>((ref, offerId) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getMessages(offerId);
});

final chatDealContextProvider = FutureProvider.family.autoDispose<Map<String, dynamic>, String>((ref, offerId) async {
  final client = Supabase.instance.client;
  final data = await client.from('offers').select('*, items(*)').eq('id', offerId).single();
  return data;
});
