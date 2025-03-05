import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/sport/sport.dart';

class SportsService {
  Future<List<Sport>> getSports() async {
    final response = await Supabase.instance.client
        .from('sports')
        .select();

    return (response as List<dynamic>).map((item) {
      return Sport(name: item['name'], id: item['id']);
    }).toList();
  }
}