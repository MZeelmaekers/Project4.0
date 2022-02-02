import 'package:http/http.dart' as http;
import 'package:localization/src/localization_extension.dart';
import 'dart:convert';
import '../models/plant.dart';

import 'package:project40_mobile_app/global_vars.dart' as global;

class PlantApi {
  static String server =
      "project40-api-dot-net20220124112651.azurewebsites.net";

  static Future<List<Plant>> fetchPlants() async {
    var url = Uri.https(server, '/api/Plant');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse.map((plant) => Plant.fromJson(plant)).toList();
    } else {
      throw Exception("plant_api-failed_plants_text".i18n());
    }
  }

  static Future<List<Plant>> fetchPlantsFromUserId(int id) async {
    var url = Uri.https(server, '/api/Plant/User/' + id.toString());

    final response = await http
        .get(url, headers: {"Authorization": "Bearer " + global.userToken});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse.map((plant) => Plant.fromJson(plant)).toList();
    } else {
      throw Exception("plant_api-failed_plant_text".i18n());
    }
  }

  static Future<Plant> fetchPlant(int id) async {
    var url = Uri.https(server, '/api/Plant/' + id.toString());

    final response = await http
        .get(url, headers: {"Authorization": "Bearer " + global.userToken});

    if (response.statusCode == 200) {
      return Plant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("plant_api-failed_plant_text".i18n());
    }
  }

  static Future<int> createPlant(Plant plant) async {
    var url = Uri.https(server, '/api/Plant');
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + global.userToken
      },
      body: jsonEncode(plant),
    );
    if (response.statusCode != 201) {
      throw Exception("plant_api-failed_create_plant_text".i18n());
    } else {
      var id = json.decode(response.body)["id"];
      return id;
    }
  }

  static Future deletePlant(int id) async {
    var url = Uri.https(server, '/api/Plant/' + id.toString());

    final http.Response response = await http
        .delete(url, headers: {"Authorization": "Bearer " + global.userToken});
    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception('plant_api-failed_delete_plant_text'.i18n());
    }
  }
}
