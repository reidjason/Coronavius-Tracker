import 'dart:convert';

import 'package:covid_19_tracker/Region.dart';
import 'package:http/http.dart' as http;

class Services {
  static Future<List<Region>> fetchRegions() async {
    final response = await http.get('https://covid19.mathdro.id/api/confirmed');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((region) => new Region.fromJson(region)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}
