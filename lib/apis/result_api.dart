import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/result.dart';

import 'package:project40_mobile_app/global_vars.dart' as global;

class ResultApi {
  static String server =
      "project40-api-dot-net20220124112651.azurewebsites.net";

  static Future<List<Result>> fetchResults() async {
    var url = Uri.https(server, '/api/Result');

    final response = await http
        .get(url, headers: {"Authorization": "Bearer " + global.userToken});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((result) => Result.fromJson(result)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  static Future<Result> fetchResult(int id) async {
    var url = Uri.https(server, '/api/Result/' + id.toString());

    final response = await http
        .get(url, headers: {"Authorization": "Bearer " + global.userToken});
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Result");
    }
  }

  static Future<Result> createResult(Result result) async {
    var url = Uri.https(server, '/api/Result');
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + global.userToken
      },
      body: jsonEncode(result),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to create Plant");
    } else {
      return Result.fromJson(jsonDecode(response.body));
    }
  }
}
