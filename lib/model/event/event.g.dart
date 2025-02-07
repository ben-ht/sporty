// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      (json['id'] as num?)?.toInt(),
      json['title'] as String?,
      json['description'] as String?,
      json['date'] as String?,
      json['location'] as String?,
    )
      ..sports = json['sports'] as List<dynamic>?
      ..maxParticipants = (json['maxParticipants'] as num?)?.toInt();

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date,
      'location': instance.location,
      'sports': instance.sports,
      'maxParticipants': instance.maxParticipants,
    };
