import "package:intl/intl.dart";

final DateFormat formatter = DateFormat("dd/MM/yyyy H:m:s");

class Result {
  int id;
  String prediction;
  double accuracy;
  String createdAt;

  Result(
      {required this.id,
      required this.prediction,
      required this.accuracy,
      required this.createdAt});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
        id: json['id'],
        prediction: json['prediction'],
        accuracy: json['accuracy'],
        createdAt: formatter.format(DateTime.parse(json['createdAt'])));
  }

  Map<String, dynamic> toJson() => {
        'prediction': prediction,
        'accuracy': accuracy,
      };
}
