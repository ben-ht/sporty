import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sporty/model/event/event.dart';
import 'package:sporty/ui/search/event_card.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    String jsonString = await rootBundle.loadString('public/data/events.json');
    List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      _allEvents = Event.fromJsonList(jsonList);
      _filteredEvents = Event.fromJsonList(jsonList);
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _filteredEvents = _allEvents
          .where((event) =>
              event.title!.toLowerCase().contains(query.toLowerCase()) ||
              event.sports!.any(
                  (sport) => sport.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Center(
              child: Image.asset(
                'public/img/sportyLogo.png',
                height: 120, // Ajuste la taille
              ),
            ),
          ),

          // Barre de recherche stylisée
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: _handleSearch,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: 'Rechercher un événement...',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  prefixIcon: Icon(Icons.search, color: Colors.green),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Liste des événements
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _filteredEvents.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: EventCard(_filteredEvents[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


