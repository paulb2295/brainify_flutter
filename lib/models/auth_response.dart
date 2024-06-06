class AuthResponse {

  final String accessToken;
  final String refreshToken;

  AuthResponse({required this.accessToken, required this.refreshToken});

  factory AuthResponse.fromJson(Map<String, dynamic> map){
    return AuthResponse(
      accessToken: map['access_token'] ?? '',
      refreshToken: map['refresh_token'] ?? ''
    );
  }
}