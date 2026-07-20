class Message {
  final int id;
  final String sender;
  final String avatar;
  final String lastMessage;
  final DateTime time;
  final int unreadCount;

  Message({
    required this.id,
    required this.sender,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
  });
}

class ChatMessage {
  final int id;
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessage({required this.id, required this.text, required this.isMe, required this.time});
}
