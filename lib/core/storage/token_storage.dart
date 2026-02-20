import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _expiresKey = 'expires_at';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
    await _storage.write(
        key: _expiresKey, value: expiresAt.toIso8601String());
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  Future<DateTime?> getExpiresAt() async {
    final value = await _storage.read(key: _expiresKey);
    if (value == null) return null;
    return DateTime.parse(value);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}