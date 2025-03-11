import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sporty/model/event/event.dart';

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
    // Get the event location as a LatLng for the map
    final LatLng eventLocation = LatLng(
      widget.event.latitude,
      widget.event.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            // Google Map
            SizedBox(
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

            // Event Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sport Type
                  Row(
                    children: [
                      Icon(Icons.sports, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Sport: ${widget.event.sport?.name}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Date and Time
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Date: ${_formatDate(widget.event.date)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Participants
                  Row(
                    children: [
                      Icon(Icons.people, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Max Participants: ${widget.event.maxParticipants}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement join event functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Joining event: ${widget.event.title}')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Join Event'),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}