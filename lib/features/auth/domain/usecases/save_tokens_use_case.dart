import 'package:crv_reprosisa/features/auth/domain/entities/auth_tokens.dart';
import 'package:crv_reprosisa/features/auth/domain/repositories/token_repository.dart';

class SaveTokensUseCase {
  final TokenRepository repository;

  SaveTokensUseCase(this.repository);

  Future<void> call(AuthTokens tokens) {
    return repository.save(tokens);
  }
}
