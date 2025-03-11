import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sporty/data/service/events_service.dart';
import 'package:sporty/model/event/event.dart';

import '../core/shared/event_card.dart';

class EventFeed extends StatefulWidget {
  const EventFeed({super.key});

  @override
  createState() => _EventFeedPageState();
}

class _EventFeedPageState extends State<EventFeed> {
  late Position _currentPosition;
  bool _locationLoaded = false;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // _fetchEvents();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      SystemNavigator.pop();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        SystemNavigator.pop();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      SystemNavigator.pop();
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      _locationLoaded = true;
    });
  }

  // Future<void> _fetchEvents() async {
  //   try {
  //     // final eventService = Provider.of<EventsService>(context, listen: false);
  //     final events = await eventService.getEvents();
  //     setState(() {
  //       _events = events;
  //     });
  //   } catch (error) {
  //     print('Error fetching events: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_locationLoaded
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          Event event = _events[index];
          return EventCard(
            event,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/event_details',
                arguments: event,
              );
            },
          );
        },
      ),
    );
  }
}
