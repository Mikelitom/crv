import 'package:crv_reprosisa/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import './user_management_remote_datasource.dart';

class UserManagementRemoteDatasourceImpl implements UserManagementRemoteDatasource {
  final Dio dio;

  UserManagementRemoteDatasourceImpl(this.dio);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await dio.get("/users/");

    final List data = response.data;

    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<UserModel> updateUser({
    required String userId,
    String? role,
    String? area,
    bool? isActive,
  }) async {
    // Creamos un mapa con solo los datos que no son nulos
    final Map<String, dynamic> updateData = {};
    if (role != null) updateData['role'] = [role]; // Si el rol es lista en tu entidad
    if (area != null) updateData['area'] = area;
    if (isActive != null) updateData['isActive'] = isActive;

    final response = await dio.patch(
      "/users/$userId/",
      data: updateData,
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<Unit> deleteUser(String userId) async {
    await dio.delete("/users/$userId/");
    return unit;
  }
}