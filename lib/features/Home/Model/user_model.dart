class UserModel {
  String? name;
  String? email;
  String? familyCode;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      familyCode: json['family_code'],
    );
  }

  UserModel({this.name, this.email, this.familyCode});
}
