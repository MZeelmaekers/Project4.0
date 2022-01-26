import "package:intl/intl.dart";
import "package:project40_mobile_app/models/result.dart";
import "package:project40_mobile_app/models/user.dart";
import "package:project40_mobile_app/models/camerabox.dart";

// Formatter for createdAt
final DateFormat formatter = DateFormat("dd/MM/yyyy HH:mm:ss");

class Plant {
  int id;
  int userId;
  int resultId;
  String fotoPath;
  String location;
  String createdAt;
  Result? result;
  User? user;

  Plant({
    required this.id,
    required this.userId,
    required this.resultId,
    required this.fotoPath,
    required this.location,
    required this.createdAt,
    this.result,
    this.user,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      userId: json['userId'],
      // Checks if result is Not null otherwise return ""
      resultId: json['resultId'] ?? 0,
      fotoPath: json['fotoPath'],
      location: json['location'],
      // Format the date to remove T and Z in the date (look api call)
      createdAt: formatter.format(DateTime.parse(json['createdAt'])),
      result: Result.fromJson(json["result"] ?? {}),
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'resultId': resultId,
        'fotoPath': fotoPath,
        'location': location
      };
}
