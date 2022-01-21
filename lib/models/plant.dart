import "package:intl/intl.dart";

// Formatter for createdAt
final DateFormat formatter = DateFormat("dd/MM/yyyy H:m:s");

class Plant {
  String id;
  String userId;
  String resultId;
  String cameraBoxId;
  String fotoPath;
  String location;
  String createdAt;

  Plant(
      {required this.id,
      required this.userId,
      required this.resultId,
      required this.cameraBoxId,
      required this.fotoPath,
      required this.location,
      required this.createdAt});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        id: json['_id'],
        userId: json['userId'],
        // Checks if result is Not null otherwise return ""
        resultId: json['resultId'] ?? "",
        cameraBoxId: json['cameraBoxId'] ?? "",
        fotoPath: json['fotoPath'],
        location: json['location'],
        // Format the date to remove T and Z in the date (look api call)
        createdAt: formatter.format(DateTime.parse(json['createdAt'])));
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'resultId': resultId,
        'cameraBoxId': cameraBoxId,
        'fotoPath': fotoPath,
        'location': location
      };
}
