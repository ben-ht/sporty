import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    setState(() {}); // Recharger les messages après envoi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.eventTitle)),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getChatMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun message pour ce chat.'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final username = message['profiles']?['username'] ?? 'Utilisateur inconnu';

                      return ListTile(
                        title: Text(message['message']),
                        subtitle: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  );
                }
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
