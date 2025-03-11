import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sporty/model/event/event.dart';
import 'package:sporty/ui/search/event_card.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SupabaseClient _client = Supabase.instance.client;
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  /// Récupération des événements disponibles (où l'utilisateur N'EST PAS participant)
  Future<void> _fetchEvents() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous devez être connecté pour voir les événements.")),
      );
      return;
    }

    final now = DateTime.now().toIso8601String();

    try {
      // Étape 1 : Récupérer les événements où l'utilisateur est déjà participant
      final participantResponse = await _client
          .from('participants')
          .select('eventId')
          .eq('userId', user.id);

      print('Participant response: $participantResponse');

      final List<int> joinedEventIds = participantResponse.map<int>((p) => p['eventId'] as int).toList();

      // Étape 2 : Récupérer les événements disponibles en excluant ceux déjà rejoints
      var query = _client
          .from('events')
          .select('''
          id, title, description, creatorId, date, longitude, latitude, maxParticipants, createdAt, place,
          sports (id, name)
        ''')
          .gt('date', now); // Filtrer les événements passés

      print('Joined event IDs: $joinedEventIds');

      // Exclure les événements déjà rejoints
      if (joinedEventIds.isNotEmpty) {
        query = query.not('id', 'in', joinedEventIds);
      }

      final response = await query;

      print('Events response: $response');

      List<Event> events = response.map<Event>((map) => Event.fromMap(map)).toList();

      print('Events: $events');

      setState(() {
        _allEvents = events;
        _filteredEvents = events;
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des événements : $error")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Recherche parmi les événements
  void _handleSearch(String query) {
    setState(() {
      _filteredEvents = _allEvents.where((event) =>
      event.title.toLowerCase().contains(query.toLowerCase())
          // ||
          // event.sport?.name.toLowerCase().contains(query.toLowerCase())
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredEvents.isEmpty
                ? Center(child: Text("Aucun événement disponible"))
                : DraggableScrollableSheet(
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
                      return EventCard(
                        event: _filteredEvents[index],
                        onJoin: _fetchEvents, // Rafraîchir après inscription
                      );
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
