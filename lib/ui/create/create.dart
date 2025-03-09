import 'package:flutter/material.dart';

class CreateApp extends StatelessWidget {
  const CreateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event Page'),
      ),
      body: Center(
        child: Text('This is the Create Event Page'),
      )


      // theme: ThemeData(useMaterial3: true),
    );
  }
}