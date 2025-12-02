
class ChildModel {
  String? name;
  String? code;
  String? gender; 
  int? points;


  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      name: json['name'],
      code: json['code'],
      gender: json['gender'],
      points: json['points'] != null ? int.tryParse(json['points'].toString()) : 0, 
    );
  }

  ChildModel({
    this.name,
    this.code,
    this.gender,
    this.points,
  });
}