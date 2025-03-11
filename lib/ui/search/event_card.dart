import 'package:flutter/material.dart';
import 'package:sporty/model/event/event.dart';

class EventCard extends StatelessWidget {
  final Event event ;

  EventCard(this.event) ;

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
                  Text('Lieu:'),
                  SizedBox(height: 8),
                  Text('Sports: ${event.sport}'),
                  SizedBox(height: 8),
                  Text('Participants: ${event.maxParticipants}'),
                ],
              ),
            ),
          ]
        )
      ),
    ) ;
  }
}