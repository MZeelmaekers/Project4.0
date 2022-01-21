import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/result.dart';

class ResultApi {
  static String server = "project-api-gateway.herokuapp.com";

  static Future<List<Result>> fetchResults() async {
    var url = Uri.https(server, 'results');

    final response = await http.get(url);

    print(response);
    if (response.statusCode == 200) {
      print(response.body);
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((result) => Result.fromJson(result)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  static Future<Result> fetchResult(String id) async {
    var url = Uri.https(server, '/results/' + id.toString());

    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Result");
    }
  }
}
