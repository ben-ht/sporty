import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sporty/model/event/event.dart';
import 'package:sporty/ui/search/event_card.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  // final TextEditingController _searchController = TextEditingController();
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState() ;
    _loadActivities() ;
  }

  Future<void> _loadActivities() async {
    String jsonString = await rootBundle.loadString('public/data/events.json');
    List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      _allEvents = Event.fromJsonList(jsonList);
      _filteredEvents = Event.fromJsonList(jsonList) ;
    });
  }


  void _handleSearch(String query) {
    setState(() {
      _filteredEvents = _allEvents.where((event) =>
        event.title!.toLowerCase().contains(query.toLowerCase()) ||
        event.sports!.any((sport) => 
          // sport.name.toLowerCase().contains(query.toLowerCase()))
          sport.toLowerCase().contains(query.toLowerCase()))
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
                      // controller: _searchController, // utile ?
                      onChanged: (value) => _handleSearch(value),
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
                      // return ListTile(
                      //   title: Text(_filteredEvents[index].title ?? 'toto'),
                      //   // subtitle: Text(_filteredEvents[index].sports!.map((s) => s.name).join(', ')),
                      //   subtitle: Text(_filteredEvents[index].sports!.join(', ')),
                      // );
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