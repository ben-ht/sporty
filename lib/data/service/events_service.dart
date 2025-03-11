import 'package:sporty/model/event/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class EventsService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Event>> getEvents() async {
    final client = Supabase.instance.client;

    try {
      final data = await client
          .from('events')
          .select('*');

      return (data as List)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();

    } catch (error) {
      print('Error fetching events: $error');
      return [];
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