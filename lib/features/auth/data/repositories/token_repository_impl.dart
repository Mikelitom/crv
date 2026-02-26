import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  final FlutterSecureStorage storage;

  TokenRepositoryImpl(this.storage);

  static const _key = 'auth_tokens';

  @override
  Future<void> save(AuthTokens tokens) async {
    final data = jsonEncode({
      'accessToken': tokens.accessToken,
      'refreshToken': tokens.refreshToken,
      'tokenType': tokens.tokenType,
      'expiresAt': tokens.expiresAt.toIso8601String(),
    });

    await storage.write(key: _key, value: data);
  }

  @override
  Future<AuthTokens?> get() async {
    final data = await storage.read(key: _key);

    if (data == null) return null;

    final decoded = jsonDecode(data);

    return AuthTokens(
      accessToken: decoded['accessToken'],
      refreshToken: decoded['refreshToken'],
      tokenType: decoded['tokenType'],
      expiresAt: DateTime.parse(decoded['expiresAt']),
    );
  }

  @override
  Future<void> clear() async {
    await storage.delete(key: _key);
  }
}
