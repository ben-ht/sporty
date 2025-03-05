import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sporty/ui/signup/widgets/sport_button.dart';
import 'package:sporty/utils/constants/size.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/service/sports_service.dart';
import '../../../model/sport/sport.dart';

class SportsSelection extends StatefulWidget {
  const SportsSelection({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SportsSelectionState();
  }
}

class _SportsSelectionState extends State<SportsSelection> {

  final SportsService sportsService = SportsService();
  final List<String> selectedSports = [];

  void _updateSelectedSports(String sportName, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedSports.add(sportName);
      } else {
        selectedSports.remove(sportName);
      }
    });
  }

  Future<bool> saveSports() async {
    if (selectedSports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sélectionne au moins un sport")),
      );
      return false;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur, veuillez redémarrer l'application")),
      );
      return false;
    }

    final response = await Supabase.instance.client
        .from('sports')
        .select('id, name')
        .filter('name', 'in', selectedSports);

    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la récupération des sports")),
      );
      return false;
    }

    final List<Map<String, dynamic>> preferences = response.map((sport) {
      return {
        'userId': user.id,
        'sportId': sport['id'],
      };
    }).toList();

    final insertResponse = await Supabase.instance.client
        .from('sportPreferences')
        .insert(preferences);

    if (insertResponse != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'enregistrement des sports")),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Sport>>(
      future: sportsService.getSports(),
      builder: (context, snapshot) {
        Iterable<Sport> sports = snapshot.data ?? [];
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Choisis tes sports (minimum 1)',
                    style: Theme.of(context).textTheme.headlineMedium!.apply(fontSizeFactor: .8)),
                  SizedBox(height: Sizes.spaceSections),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: Sizes.spaceItems,
                        mainAxisSpacing: Sizes.spaceItems,
                        childAspectRatio: 3
                      ),
                      itemCount: sports.length,
                      itemBuilder: (context, index) {
                        return SportButton(
                          sportName: sports.elementAt(index).name,
                          onSelectionChanged: _updateSelectedSports,
                        );
                      }
                    )
                  ),
                  SizedBox(height: Sizes.spaceSections),
                  ElevatedButton(
                    onPressed: () async {
                      final response = await saveSports();
                      if (response)
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    },
                    child: Text('C\'est parti !')
                  )
                ]
              ),
            ),
          ),
        );
      },
    );
  }


}