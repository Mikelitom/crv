import '../../domain/entities/auth_tokens.dart';

class AuthTokensModel extends AuthTokens {
  AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresAt,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }
}