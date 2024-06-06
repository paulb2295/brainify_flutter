class ChangePasswordRequest {

  final String currentPassword;
  final String newPassword;
  final String confirmationPassword;

  ChangePasswordRequest({
      required this.currentPassword, required this.newPassword, required this.confirmationPassword});

  Map<String, dynamic> toJson(){
    return {
      'currentPassword' : currentPassword,
      'newPassword' : newPassword,
      'confirmationPassword' : confirmationPassword
    };
  }
}