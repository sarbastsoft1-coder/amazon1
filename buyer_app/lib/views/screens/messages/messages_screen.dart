import 'package:flutter/material.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text('S${index + 1}', style: const TextStyle(color: Colors.white)),
              ),
              title: Text('Seller ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Last message preview...'),
              trailing: const Text('10:30 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
              onTap: () => Navigator.pushNamed(context, AppRoutes.chat, arguments: {'sellerName': 'Seller ${index + 1}'}),
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String sellerName;
  const ChatScreen({super.key, required this.sellerName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _messages = [
    {'text': 'Hello, is this available?', 'isMe': false, 'time': '10:00'},
    {'text': 'Yes, it is available.', 'isMe': true, 'time': '10:05'},
  ];

  void _send() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _messages.add({'text': _controller.text, 'isMe': true, 'time': 'Now'});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.sellerName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] == true;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? AppTheme.primaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'] as String, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppTheme.primaryColor),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
