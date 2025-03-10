import 'dart:ffi';

class ChatModel {
  final Int8 id;
  final Int8 event_id;

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