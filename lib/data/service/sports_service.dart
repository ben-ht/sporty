import '../../model/sport/sport.dart';

class SportsService {
  var sports = <Sport>[
    Sport(name: 'Football'),
    Sport(name: 'Basketball'),
    Sport(name: 'Tennis'),
    Sport(name: 'Volleyball'),
    Sport(name: 'Handball'),
  ];

  Future<Iterable<Sport>> getSports() async {
    return sports;
  }
}