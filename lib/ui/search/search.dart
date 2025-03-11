import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sporty/model/event/event.dart';
import 'package:sporty/ui/core/shared/event_card.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SupabaseClient _client = Supabase.instance.client;

  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final response = await _client.from('events').select('''
      id, title, description, creatorId, date, longitude, latitude, maxParticipants, createdAt,
      sports (id, name)
    ''');

    List<Event> events = response.map<Event>((json) => Event.fromJson(json)).toList();

    setState(() {
      _allEvents = events;
      _filteredEvents = events;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _filteredEvents = _allEvents.where((event) =>
      event.title.toLowerCase().contains(query.toLowerCase()) ||
          event.sport.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('public/img/sportyLogo.png', height: 200),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _handleSearch,
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: DraggableScrollableSheet(
              initialChildSize: 1.0,
              minChildSize: 1.0,
              maxChildSize: 1.0,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      return EventCard(_filteredEvents[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
