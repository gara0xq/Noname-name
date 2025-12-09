class ChildModel {
  final String name;
  final String code;
  final String gender;
  final int points;

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      name: json['name'],
      code: json['code'],
      gender: json['gender'],
      points: json['points'],
    );
  }

  ChildModel({
    required this.name,
    required this.code,
    required this.gender,
    required this.points,
  });
}
