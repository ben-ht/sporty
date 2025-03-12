import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sporty/data/service/events_service.dart';
import 'package:sporty/model/event/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventDetail extends StatefulWidget {
  final Event event;

  const EventDetail({
    super.key,
    required this.event,
  });

  @override
  createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetail> {
  late GoogleMapController mapController;
  late Set<Marker> markers;

  @override
  void initState() {
    super.initState();
    // Initialize the markers set with a marker at the event's location
    markers = {
      Marker(
        markerId: MarkerId('event-location'),
        position: LatLng(widget.event.latitude, widget.event.longitude),
        infoWindow: InfoWindow(
          title: widget.event.title,
          snippet: 'Event Location',
        ),
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final LatLng eventLocation = LatLng(
      widget.event.latitude,
      widget.event.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.event.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),

            // Google Map
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: eventLocation,
                    zoom: 15.0,
                  ),
                  markers: markers,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Event Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(context, Icons.place, 'Lieu: ${widget.event.place}'),
                      _buildInfoRow(context, Icons.sports, 'Sport: ${widget.event.sport?.name ?? 'Unknown'}'),
                      _buildInfoRow(context, Icons.calendar_today, 'Date: ${_formatDate(widget.event.date)}'),
                      _buildInfoRow(context, Icons.people, 'Participants: ${widget.event.maxParticipants}'),
                      SizedBox(height: 32),
                      Text(
                        'Description',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.event.description,
                        style: theme.textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white70,
              padding: const EdgeInsets.all(14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              await Provider.of<EventsService>(context, listen: false)
                  .joinEvent(Supabase.instance.client.auth.currentUser!, widget.event);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Vous avez rejoint: ${widget.event.title}'),
                  backgroundColor: colorScheme.secondary,
                ),
              );
            },
            child: const Text('Rejoindre',
                style: TextStyle(
                    fontSize: 16,
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}