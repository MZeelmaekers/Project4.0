import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/plant.dart';

class PlantApi {
  static String server = "project-api-gateway.herokuapp.com";

  static Future<List<Plant>> fetchPlants() async {
    var url = Uri.https(server, 'plants');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((plant) => Plant.fromJson(plant)).toList();
    } else {
      throw Exception("Failed to load plants");
    }
  }

  static Future<Plant> fetchPlant(String id) async {
    var url = Uri.https(server, 'plants/' + id.toString());

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Plant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load plant");
    }
  }
}
