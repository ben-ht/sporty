import 'dart:ffi';

class ChatMessageModel {
  final Int8 id;
  final DateTime created_at;
  final Int8 chat_id;
  final String user_id;
  final String message;

  ChatMessageModel({
    required this.id,
    required this.created_at,
    required this.chat_id,
    required this.user_id,
    required this.message
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': created_at,
      'chat_id': chat_id,
      'user_id': user_id,
      'message': message
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
        id: map['id'],
        created_at: map['created_at'],
        chat_id: map['chat_id'],
        user_id: map['user_id'],
        message: map['message']
    );
  }
}