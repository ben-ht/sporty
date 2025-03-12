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
      borderRadius: BorderRadius.circular(12),
      child: Card(
        //color: theme.cardColor,
        child: Container(
          padding: EdgeInsets.all(6),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 8),
                _buildInfoRow(context, Icons.description, event.description),
                _buildInfoRow(context, Icons.location_on, event.city),
                _buildInfoRow(context, Icons.sports, event.sport?.name ?? 'Unknown'),
                _buildInfoRow(context, Icons.people, '${event.maxParticipants} Participants'),
              ],
            ),
          )
        ),
      ),
    ) ;
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

}