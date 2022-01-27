import "package:intl/intl.dart";
import 'package:project40_mobile_app/models/user.dart';

final DateFormat formatter = DateFormat("dd/MM/yyyy H:m:s");

class CameraBox {
  int id;
  String qrCode;
  int userId;
  String createdAt;
  User? user;

  CameraBox(
      {required this.id,
      required this.qrCode,
      required this.userId,
      required this.createdAt,
      this.user});

  factory CameraBox.fromJson(Map<String, dynamic> json) {
      return CameraBox(
          id: json['id'],
          qrCode: json['qrCode'],
          userId: json['userId'],
          createdAt: formatter.format(DateTime.parse(json['createdAt'])),
          user: User.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() => {
        'qrCode': qrCode,
        'userId': userId,
      };
}
