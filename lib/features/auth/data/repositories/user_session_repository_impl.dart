import 'package:crv_reprosisa/features/auth/domain/repositories/user_session_repository.dart';
import 'package:crv_reprosisa/features/auth/data/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/user.dart';

class UserSessionRepositoryImpl implements UserSessionRepository {
  final Box box;

  UserSessionRepositoryImpl(this.box);

  static const String userKey = 'current_user';

  @override
  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);

    await box.put(userKey, model.toJson());
  }

  @override
  Future<User?> getUser() async {
    final data = box.get(userKey);

    if (data == null) {
      return null;
    }

    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> clear() async {
    await box.delete(userKey);
  }
}
