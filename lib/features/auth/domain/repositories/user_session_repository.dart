import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';

abstract class UserSessionRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clear();
}
