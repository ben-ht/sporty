import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:sporty/ui/chat/chat.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _maxParticipantsController = TextEditingController();

  double? _latitude;
  double? _longitude;

  DateTime? _selectedDate;
  int? _sportId;
  List<Map<String, dynamic>> _sports = [];

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final LatLng _defaultLocation = LatLng(48.8566, 2.3522); // Default to Paris

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

  Future<void> _selectPlace(Prediction prediction) async {
    if (prediction.lat != null && prediction.lng != null) {
      final lat = prediction.lat;
      final lng = prediction.lng;
      final address = prediction.description;

      setState(() {
        _latitude = double.parse(lat!);
        _longitude = double.parse(lng!);
        _placeController.text = address ?? '';

        // Add marker
        _markers = {
          Marker(
            markerId: MarkerId('event-location'),
            position: LatLng(double.parse(lat), double.parse(lng)),
            infoWindow: InfoWindow(title: address ?? 'Selected Location'),
          )
        };

        // Move camera
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(double.parse(lat), double.parse(lng)), 15),
        );
      });
    }
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

    if (maxParticipants == null || maxParticipants < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le nombre de participants doit être un nombre positif")),
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez sélectionner un lieu sur la carte")),
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
        'longitude': _longitude,
        'latitude': _latitude,
        'city': await getCityFromCoordinates(_latitude!, _longitude!),
      }).select('id').single();

      final eventId = eventResponse['id'];

      await supabase.from('participants').insert({
        'eventId': eventId,
        'userId': user.id,
      });

      await supabase.from('chat').insert({
        'event_id': eventId,
      }).select('id').single();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Événement créé avec succès !")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatApp(),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la création: $error")),
      );
    }
  }

  void _onMapTapped(LatLng position) async {
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;

      // Update marker
      _markers = {
        Marker(
          markerId: MarkerId('event-location'),
          position: position,
          infoWindow: InfoWindow(title: 'Lieu de l\'événement'),
        )
      };
    });

    setState(() {
      _placeController.text = "Emplacement sélectionné sur la carte";
    });
  }

  Future<String?> getCityFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return place.locality;
      }

      return null;
    } catch (error) {
        print('Erreur lors du géocodage inverse: $error');
        return null;
    }
  }

  Widget _buildPlacesAutoComplete() {
    return GooglePlaceAutoCompleteTextField(
      focusNode: _focusNode,
      textEditingController: _placeController,
      googleAPIKey: "AIzaSyB5TV0G7ArU7al4PIfw7tcPooE2rZHxYRU",
      inputDecoration: InputDecoration(
        labelText: "Rechercher un lieu",
        suffixIcon: Icon(Icons.search),
      ),
      debounceTime: 400,
      countries: ["fr"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        if (prediction.lat != null && prediction.lng != null) {
          setState(() {
            _latitude = double.parse(prediction.lat!);
            _longitude = double.parse(prediction.lng!);

            // Add marker
            if (_latitude != null && _longitude != null) {
              _markers = {
                Marker(
                  markerId: MarkerId('event-location'),
                  position: LatLng(_latitude!, _longitude!),
                  infoWindow: InfoWindow(title: prediction.description ?? 'Selected Location'),
                )
              };

              // Move camera
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(LatLng(_latitude!, _longitude!), 15),
              );
            }
          });
        }
      },
      itemClick: (Prediction prediction) {
        _placeController.text = prediction.description ?? "";
        _placeController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0));
      },
      seperatedBuilder: Divider(),
      containerHorizontalPadding: 10,
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 7),
              Expanded(child: Text("${prediction.description ?? ""}"))
            ],
          ),
        );
      },
      isCrossBtnShown: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un événement"),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
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
                    SizedBox(height: 16),

                    // Place search with autocomplete
                    _buildPlacesAutoComplete(),

                    SizedBox(height: 16),

                    // Map view
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _latitude != null && _longitude != null
                                ? LatLng(_latitude!, _longitude!)
                                : _defaultLocation,
                            zoom: 14,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          onTap: _onMapTapped,
                        ),
                      ),
                    ),

                    if (_latitude != null && _longitude != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                      ),

                    SizedBox(height: 16),
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

                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          // Now pick time
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            setState(() {
                              _selectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text(_selectedDate == null
                          ? "Sélectionner une date et heure"
                          : "Date : ${_formatDateTime(_selectedDate!)}"),
                    ),

                    SizedBox(height: 16),
                    DropdownButton<int>(
                      value: _sportId,
                      hint: Text("Sélectionnez un sport"),
                      isExpanded: true,
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
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _createEvent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Créer l'événement",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "$day/$month/$year à $hour:$minute";
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _placeController.dispose();
    _maxParticipantsController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}