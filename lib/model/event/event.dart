import 'package:json_annotation/json_annotation.dart' ;

part 'event.g.dart';

@JsonSerializable()
class Event {
  int? id ;

  String? title ;

  String? description;

  String? date ;

  String? location ;

  List<dynamic>? sports;

  int? maxParticipants ;



  Event(this.id, this.title, this.description, this.date, this.location);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json) ;

  Map<String, dynamic> toJson() => _$EventToJson(this) ;

  static List<Event> fromJsonList(List list) {
    return list.map((item) => Event.fromJson(item)).toList() ;
  }

}