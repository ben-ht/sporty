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
  Position? _currentPosition;
  bool _isLoadingEvents = true;
  List<Event> _events = [];

  // Create a refresh controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load both in parallel
    _initializeLocationAndEvents();
  }

  Future<void> _initializeLocationAndEvents() async {
    // Start both processes simultaneously
    Future<void> locationFuture = _getCurrentLocation();
    Future<void> eventsFuture = _fetchEvents();

    // Wait for both to complete
    await Future.wait([eventsFuture, locationFuture]);
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        // Don't exit the app, just continue without location
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          // Don't exit the app, just continue without location
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        // Don't exit the app, just continue without location
        return;
      }

      // Get position with a timeout
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 5),
      ).catchError((e) {
        print('Location timeout: $e');
        return null;
      });

      // Refresh events with location if we got it after events loaded
      if (_events.isNotEmpty && _currentPosition != null) {
        _fetchEvents();
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchEvents() async {
    try {
      setState(() {
        _isLoadingEvents = true;
      });

      final eventService = Provider.of<EventsService>(context, listen: false);
      final events = await eventService.getEvents();

      print('Events: $events.toString()');

      setState(() {
        _events = events;
        _isLoadingEvents = false;
      });
    } catch (error) {
      print('Error fetching events: $error');
      setState(() {
        _isLoadingEvents = false;
      });
    }
  }

  Future<void> _refreshData() async {
    // Refresh both location and events
    await _initializeLocationAndEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoadingEvents && _events.isEmpty
            ? _buildSkeletonLoader()
            : _events.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    // Show a more engaging loading state than just a spinner
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: 5, // Show 5 skeleton items
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 120,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 24,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.grey[200],
                ),
                SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.grey[200],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Aucun événement trouvé",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Tirez vers le bas pour rafraîchir",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}