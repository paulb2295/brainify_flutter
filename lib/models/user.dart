import '../utils/enums/roles_enum.dart';

class User {

  final String email;
  final String firstName;
  final String lastName;
  final Role? role;

  User({
    required this.email, required this.firstName, required this.lastName, this.role});

  Map<String, dynamic> toJson(){
    return {
      'email' : email,
      'firstName' : firstName,
      'lastName' : lastName,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        role: json['role'] == 'ADMIN'? Role.ADMIN : (json['role'] == 'INSTRUCTOR'? Role.INSTRUCTOR : Role.STUDENT)
    );
  }
}