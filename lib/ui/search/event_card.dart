import 'package:flutter/material.dart';
import 'package:sporty/model/event/event.dart';

class EventCard extends StatelessWidget {
  final Event event ;

  const EventCard(this.event, {super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(6),
        child: ExpansionTile(
          leading: Icon(Icons.event),
          title: Text(event.title ?? 'Événement sans titre'),
          subtitle: Text(event.date ?? 'Date non spécifiée'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${event.description ?? 'Aucune description'}'),
                  SizedBox(height: 8),
                  Text('Lieu: ${event.location ?? 'Non spécifié'}'),
                  SizedBox(height: 8),
                  Text('Sports: ${event.sports?.join(', ') ?? 'Aucun sport spécifié'}'),
                  SizedBox(height: 8),
                  Text('Participants: ${event.maxParticipants ?? 'Non spécifié'}'),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: const Color.fromARGB(255, 0, 113, 83), width: 2),
                        // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                        print("Rejoindre l'événement: ${event.title}");
                      },
                      child: Text("Rejoindre"),
                    ),
                  ),


                ],
              ),
            ),
          ]
        )
      ),
    ) ;
  }
}