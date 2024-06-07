import '../utils/enums/roles_enum.dart';

class User {
  final int? id;
  final String email;
  final String firstName;
  final String lastName;
   Role? role;

  User(
      {this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      this.role});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role?.name ?? Role.STUDENT
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        role: json['role'] == 'ADMIN'
            ? Role.ADMIN
            : (json['role'] == 'INSTRUCTOR' ? Role.INSTRUCTOR : Role.STUDENT));
  }
}
