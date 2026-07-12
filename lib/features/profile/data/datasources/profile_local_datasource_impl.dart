import 'package:crv_reprosisa/features/auth/data/models/user_model.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:hive/hive.dart';

class ProfileLocalDatasourceImpl implements ProfileLocalDatasource {
  final Box box;

  static const _key = 'current_user';

  ProfileLocalDatasourceImpl(this.box);

  @override
  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    await box.put(_key, model.toJson());
  }

  @override
  Future<User?> getUser() async {
    final data = box.get(_key);
    
    if (data == null) return null;
    
    return UserModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  @override
  Future<void> clearUser() async {
    await box.delete(_key);
  }
}
