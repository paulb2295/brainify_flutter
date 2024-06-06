import '../utils/enums/roles_enum.dart';

class RegisterRequest {

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final Role? role;

  RegisterRequest({
      required this.email, required this.password, required this.firstName, required this.lastName, this.role});

  Map<String, dynamic> toJson(){
    return {
      'email' : email,
      'password' : password,
      'firstName' : firstName,
      'lastName' : lastName,
    };
  }
}