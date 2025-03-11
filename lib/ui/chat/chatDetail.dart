import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class ChatDetailPage extends StatefulWidget {
  final int chatId;
  final String eventTitle;

  const ChatDetailPage({super.key, required this.chatId, required this.eventTitle});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  Timer? _timer;
  List<Map<String, dynamic>> _messages = [];
  final user = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final messages = await _getChatMessages();
      setState(() {
        _messages = messages;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getChatMessages() async {
    final response = await Supabase.instance.client
        .from('chatMessage')
        .select('message, created_at, user_id, profiles(username)')
        .eq('chat_id', widget.chatId)
        .order('created_at', ascending: true);

    return response;
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('chatMessage').insert({
      'chat_id': widget.chatId,
      'user_id': user.id,
      'message': _messageController.text,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.eventTitle)),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final username = message['profiles']?['username'] ?? 'Utilisateur inconnu';
                final isAuthor = message['user_id'] == user?.id;

                return Align(
                  alignment: isAuthor ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: isAuthor ? Colors.blue[50] : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: isAuthor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: TextStyle(
                            color: isAuthor ? Colors.blue : Colors.black,
                            fontWeight: isAuthor ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAuthor ? Colors.blue : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Écrire un message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}