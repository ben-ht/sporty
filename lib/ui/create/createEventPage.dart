import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../chat/chatDetail.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _maxParticipantsController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  DateTime? _selectedDate;
  int? _sportId;
  List<Map<String, dynamic>> _sports = [];

  @override
  void initState() {
    super.initState();
    _fetchSports();
  }

  Future<void> _fetchSports() async {
    final response = await supabase.from('sports').select('id, name');
    setState(() {
      _sports = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null || _sportId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous devez être connecté pour créer un événement")),
      );
      return;
    }

    int? maxParticipants = int.tryParse(_maxParticipantsController.text);
    double? latitude = double.tryParse(_latitudeController.text);
    double? longitude = double.tryParse(_longitudeController.text);

    if (maxParticipants == null || maxParticipants < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le nombre de participants doit être un nombre positif")),
      );
      return;
    }

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Latitude et longitude doivent être des nombres valides")),
      );
      return;
    }

    try {
      final eventResponse = await supabase.from('events').insert({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'creatorId': user.id,
        'date': _selectedDate!.toIso8601String(),
        'place': _placeController.text,
        'createdAt': DateTime.now().toIso8601String(),
        'maxParticipants': maxParticipants,
        'sportId': _sportId,
        'longitude': longitude,
        'latitude': latitude,
      }).select('id').single();

      final eventId = eventResponse['id'];

      final chatResponse = await supabase.from('chat').insert({
        'event_id': eventId,
      }).select('id').single();

      final chatId = chatResponse['id'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Événement et chat créés avec succès !")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(chatId: chatId, eventTitle: _titleController.text),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la création: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un événement")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "Titre"),
                      validator: (value) => value!.isEmpty ? "Titre requis" : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: "Description"),
                      validator: (value) => value!.isEmpty ? "Description requise" : null,
                    ),
                    TextFormField(
                      controller: _placeController,
                      decoration: InputDecoration(labelText: "Lieu"),
                      validator: (value) => value!.isEmpty ? "Lieu requis" : null,
                    ),
                    TextFormField(
                      controller: _maxParticipantsController,
                      decoration: InputDecoration(labelText: "Nombre max de participants"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return "Ce champ est requis";
                        final num = int.tryParse(value);
                        if (num == null || num < 0) return "Entrez un nombre valide";
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(labelText: "Latitude"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return "Ce champ est requis";
                        if (double.tryParse(value) == null) return "Entrez une latitude valide";
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(labelText: "Longitude"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return "Ce champ est requis";
                        if (double.tryParse(value) == null) return "Entrez une longitude valide";
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text("Date de l'événement"),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(_selectedDate == null
                          ? "Sélectionner une date"
                          : "Date : ${_selectedDate!.toLocal()}"),
                    ),
                    SizedBox(height: 16),
                    Text("Sport"),
                    DropdownButton<int>(
                      value: _sportId,
                      hint: Text("Sélectionnez un sport"),
                      items: _sports.map((sport) {
                        return DropdownMenuItem<int>(
                          value: sport['id'],
                          child: Text(sport['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _sportId = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _createEvent,
              child: Text("Créer l'événement"),
            ),
          ),
        ],
      ),
    );
  }
}