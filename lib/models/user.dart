import "package:intl/intl.dart";

final DateFormat formatter = DateFormat("dd/MM/yyyy H:m:s");

class User {
  int id;
  String name;
  String password;
  String email;
  String address;
  String zipCode;
  String hometown;
  String createdAt;
  String token;

  User(
      {required this.id,
      required this.name,
      required this.password,
      required this.email,
      required this.address,
      required this.zipCode,
      required this.hometown,
      required this.createdAt,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        password: json['password'] ?? "",
        email: json['email'],
        address: json['address'],
        zipCode: json['zipCode'],
        hometown: json['hometown'],
        createdAt: formatter.format(DateTime.parse(json['createdAt'])),
        token: json['token'] ?? "");
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
        'email': email,
        'address': address,
        'zipCode': zipCode,
        'hometown': hometown
      };
}
