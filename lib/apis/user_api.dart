import 'package:http/http.dart' as http;
import 'package:project40_mobile_app/models/user.dart';
import 'dart:convert';
import '../models/result.dart';

import 'package:project40_mobile_app/global_vars.dart' as global;

class UserApi {
  static String server =
      "project40-api-dot-net20220124112651.azurewebsites.net";

  static Future<User> loginUser(User user) async {
    var url = Uri.https(server, '/api/User/authenticate');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login user');
    }
  }
}
