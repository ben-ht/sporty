import 'dart:ffi';

class ChatModel {
  final int id;
  final int event_id;

  ChatModel({
    required this.id,
    required this.event_id
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': event_id
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        id: map['id'],
        event_id: map['event_id']
    );
  }
}