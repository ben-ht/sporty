import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sporty/data/service/events_service.dart';
import 'package:sporty/model/event/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onJoin;

  const EventCard({super.key, required this.event, required this.onJoin});

  /// Fonction pour rejoindre un événement
  Future<void> _joinEvent(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous devez être connecté pour rejoindre un événement.")),
      );
      return; // TODO : Redirect to login
    }

    try {
      await Provider.of<EventsService>(context, listen: false).joinEvent(user, event);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous avez rejoint l'événement !")),
      );

      onJoin(); // Rafraîchir la liste après inscription
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'inscription : $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(6),
          child: ExpansionTile(
              leading: Icon(Icons.event),
              title: Text(event.title),
              subtitle: Text(event.date.toString()),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${event.description}'),
                      SizedBox(height: 8),
                      Text('Lieu: ${event.city}'),
                      SizedBox(height: 8),
                      Text('Sport: ${event.sport?.name}'),
                      SizedBox(height: 8),
                      Text('Participants max: ${event.maxParticipants}'),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _joinEvent(context),
                        child: Text("Rejoindre"),
                      ),
                    ],
                  ),
                ),
              ]
          )
      ),
    );
  }
}
