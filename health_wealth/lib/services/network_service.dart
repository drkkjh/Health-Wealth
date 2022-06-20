import 'dart:convert';
import 'package:health_wealth/model/snack_api.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  static Future<List<SnackAPI>?> getSnackInfo(String input) async {
    var uri = Uri.https(
        'calorieninjas.p.rapidapi.com', '/v1/nutrition', {'query': input});

    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': 'a1e7a45355msh97513eeb9701ec7p111fb2jsn54a66758fd4b',
      'X-RapidAPI-Host': 'calorieninjas.p.rapidapi.com',
    });

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List<SnackAPI> snacks = [];

      for (var item in data['items']) {
        snacks.add(SnackAPI.fromJson(item));
      }
      return snacks;
    }
    return null;
  }
}
