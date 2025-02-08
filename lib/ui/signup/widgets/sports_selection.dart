import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sporty/ui/signup/widgets/sport_button.dart';
import 'package:sporty/utils/constants/size.dart';

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
                  Text('Choisis tes sports (minimum 2)',
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
                        );
                      }
                    )
                  ),
                  SizedBox(height: Sizes.spaceSections),
                  ElevatedButton(
                    onPressed: () {
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