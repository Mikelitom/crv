import '../entities/auth_tokens.dart';

abstract class TokenRepository {
  Future<void> save(AuthTokens tokens);
  Future<AuthTokens?> get();
  Future<void> clear();
}
