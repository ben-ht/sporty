import 'package:sporty/model/sport/sport.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final int creatorId;
  final DateTime date;
  final double longitude;
  final double latitude;
  final Sport sport;
  final int maxParticipants;
  final DateTime createdAt;

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
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      creatorId: json['creatorId'],
      date: DateTime.parse(json['date']),
      longitude: json['longitude'],
      latitude: json['latitude'],
      sport: Sport.fromJson(json['sport']),
      maxParticipants: json['maxParticipants'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}