import 'package:facelocus/models/user_model.dart';

class TokenResponse {
  late String token;
  late DateTime expireIn;
  late List<String> groups;
  late String refreshToken;
  late UserModel user;

  TokenResponse({
    required this.token,
    required this.expireIn,
    required this.groups,
    required this.refreshToken,
    required this.user,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'],
      expireIn: DateTime.parse(json['expire_in']),
      groups: List<String>.from(json['groups']),
      refreshToken: json['refresh_token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}
