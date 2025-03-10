import 'package:flutter/material.dart';

class Creation extends StatefulWidget {
  const Creation({super.key});

  @override
  State<Creation> createState() => _CreationState();
}

class _CreationState extends State<Creation> {

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Titre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un titre';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(labelText: 'Lieu'),
          ),
          ListTile(
            // title: Text('Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
            title: Text('Date: _selectedDate'),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
          // Ici, vous pouvez ajouter un widget pour sélectionner les sports
          // Par exemple, un DropdownButton ou un MultiSelect widget
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre maximum de participants'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                // _maxParticipants = int.tryParse(value);
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Créer l\'événement'),
          ),
        ],
      ),
    );
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      
    }
  }



  
}
