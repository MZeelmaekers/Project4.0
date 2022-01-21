enum GrowthState { WEEK1, WEEK2, WEEK3, WEEK4, WEEK5, WEEK6 }

class Result {
  String id;
  String growthState;
  double accuracy;
  String createdAt;

  Result(
      {required this.id,
      required this.growthState,
      required this.accuracy,
      required this.createdAt});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
        id: json['_id'],
        growthState: json['growthState'],
        accuracy: json['accuracy'],
        createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJson() => {
        'growthState': growthState,
        'accuracy': accuracy,
      };
}
