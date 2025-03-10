import 'package:flutter/material.dart';
import 'package:sporty/model/chat/chat.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  Future<List<Map<String,dynamic>>> _getUserChats() async {
    // récupération des chats de l'utilisateur dans supabase
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    // Récupérer les eventId auxquels l'utilisateur participe
    final eventResponse = await supabase
        .from('participants')
        .select('eventId')
        .eq('userId', user.id);

    if (eventResponse.isEmpty) {
      return [];
    }

    // Extraire les eventId dans une liste
    final eventIds = eventResponse.map((e) => e['eventId']).toList();

    print('Event IDs: $eventIds');


    // Récupérer les chats avec le title de l'event associé
    final chatResponse = await supabase
        .from('chat')
        .select('id, event_id, events(title)')
        .filter('event_id','in', eventIds);

    if (chatResponse.isEmpty) {
      return [];
    }

    return chatResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUserChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune discussion disponible'));
          } else {
            final chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final eventTitle = chat['events']['title'] ?? 'Événement inconnu';

                return ListTile(
                  title: Text('Événement: $eventTitle'),
                  subtitle: Text('Chat ID: ${chat['id']}'),
                );
              },
            );
          }
        },
      ),

    );
  }
}