class ChatStrings {
  // UI Strings
  static const String regardingPrefix = "Regarding: ";
  static const String startConversationTitle = "Start the Conversation";
  static const String realTimeMessagesSubtitle = "Messages will appear in real-time.";
  static const String typeMessageHint = "Type a message...";
  static const String sendMessageError = "Failed to send message";
  static const String itemMarkedAsPrefix = "Item marked as ";
  static const String cancelDealButton = "Cancel Deal";
  static const String markAsDoneButton = "Mark as Done";
  static const String chatLoadingErrorPrefix = "Error loading chat: ";

  // Log Messages
  static const String statusUpdateError = "Status update error: ";
  static const String sendMessageErrorLog = "Error sending message: ";

  // Database Tables
  static const String tableItems = 'items';
  static const String tableMessages = 'messages';
  static const String tableOffers = 'offers';
  
  // Database Columns
  static const String colId = 'id';
  static const String colStatus = 'status';
  static const String colOfferId = 'offer_id';
  static const String colSenderId = 'sender_id';
  static const String colContent = 'content';
  static const String colCreatedAt = 'created_at';
  
  // Database Queries
  static const String queryOffersWithItems = '*, items(*)';

  // Item Status
  static const String statusAccepted = 'accepted';
  static const String statusCancelled = 'cancelled';
  static const String statusSold = 'sold';
}
