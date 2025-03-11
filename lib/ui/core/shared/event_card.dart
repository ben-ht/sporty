import 'package:flutter/material.dart';
import 'package:sporty/model/event/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const EventCard(this.event, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(6),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Description: ${event.description}'),
                SizedBox(height: 8),
                Text('Lieu:'),
                SizedBox(height: 8),
                Text('Sports: ${event.sport}'),
                SizedBox(height: 8),
                Text('Participants: ${event.maxParticipants}'),
              ],
            ),
          )
        ),
      ),
    ) ;
  }
}