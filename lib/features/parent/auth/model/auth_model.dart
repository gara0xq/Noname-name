class AuthModel {
  String first_name;
  String last_name; 
  int phone_number;
  String email;
  String password;
  String confirm_password;

  AuthModel({required this.first_name,required this.last_name,required this.phone_number,required this.email,required this.password,required this.confirm_password});
}