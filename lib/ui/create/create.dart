import 'package:flutter/material.dart';
import 'createEventPage.dart'; // Import de la page de création d'événement

class CreateApp extends StatelessWidget {
  const CreateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateEventPage(), // Appel de la page de création directement
    );
  }
}
