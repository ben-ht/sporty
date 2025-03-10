import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: Center(
        child: Text('This is the Chat Page'),
      )
    );
  }
}