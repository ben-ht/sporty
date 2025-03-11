import 'package:sporty/model/event/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class EventsService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Event>> getEvents() async {
    try {
      final data = await _client
          .from('events')
          .select('''
          id, title, description, creatorId, date, longitude, latitude, maxParticipants, createdAt, place,
          sports (id, name)
        ''');
      print('data: $data');

      List<Event> events = data.map<Event>((map) => Event.fromMap(map)).toList();
      print('events    : $events');
      // print((data as List).map((e) => Event.fromMap(e as Map<String, dynamic>)).toList());

      return events;

    } catch (error) {
      print('Error fetching events: $error');
      return [];
    }
  }

  Future<void> joinEvent(User user, Event event) async {
    try {
      await _client.from('participants').insert({
        'userId': user.id,
        'eventId': event.id,
      });
    } catch (error) {
      print('Error joining event: $error');
    }
  }

  Future<bool> createEvent({
    required String title,
    required String description,
    required int creatorId,
    required DateTime date,
    required double longitude,
    required double latitude,
    required int sportId,
    required int maxParticipants,
  }) async {
    final response = await _client.from('events').insert({
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'date': date.toIso8601String(),
      'longitude': longitude,
      'latitude': latitude,
      'sport': sportId,
      'maxParticipants': maxParticipants,
      'createdAt': DateTime.now().toIso8601String(),
    });

    return response == null;
  }
}