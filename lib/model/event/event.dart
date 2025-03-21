import 'package:sporty/model/sport/sport.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final String creatorId;
  final DateTime date;
  final double longitude;
  final double latitude;
  final Sport? sport;
  final int? maxParticipants;
  final DateTime createdAt;
  final String place;
  final String city;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.date,
    required this.longitude,
    required this.latitude,
    required this.sport,
    required this.maxParticipants,
    required this.createdAt,
    required this.place,
    required this.city
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'date': date.toIso8601String(),
      'longitude': longitude,
      'latitude': latitude,
      'sport': sport?.toMap(),
      'maxParticipants': maxParticipants,
      'createdAt': createdAt.toIso8601String(),
      'place': place,
      'city': city
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      creatorId: map['creatorId'],
      date: DateTime.parse(map['date']),
      longitude: double.parse(map['longitude'].toString()),
      latitude: double.parse(map['latitude'].toString()),
      sport: map['sports'] != null && map['sports'] is Map<String, dynamic>
          ? Sport.fromMap(map['sports'])
          : null,
      maxParticipants: map['maxParticipants'],
      createdAt: DateTime.parse(map['createdAt']),
      place: map['place'],
      city: map['city'],
    );
  }

  @override
  String toString() {
    return 'Event{id: $id, title: $title, description: $description, creatorId: $creatorId, date: $date, longitude: $longitude, latitude: $latitude, sport: $sport, maxParticipants: $maxParticipants, createdAt: $createdAt, place: $place}';
  }
}