class AuthModel {
  String firstName;
  String lastName;
  int phoneNumber;
  String email;
  String password;
  String confirmPassword;

  AuthModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
