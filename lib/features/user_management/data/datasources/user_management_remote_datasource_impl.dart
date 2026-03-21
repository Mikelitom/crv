import 'package:crv_reprosisa/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import './user_management_remote_datasource.dart';
import 'package:crv_reprosisa/core/utils/scope_mapper.dart'; 

class UserManagementRemoteDatasourceImpl implements UserManagementRemoteDatasource {
  final Dio dio;

  UserManagementRemoteDatasourceImpl(this.dio);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await dio.get("/auth/users/");
    final List data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<UserModel> updateUser({
    required String userId,
    List<String>? role, 
    String? scope,     
    bool? isActive,
  }) async {
    final Map<String, dynamic> updateData = {};
    
    // 1. Roles
    if (role != null) {
      updateData['roles'] = role; 
    }

    // 2. Scope con Mapeo (Evita Error 500)
    if (scope != null) {
      final String mappedValue = mapScope(scope);
      
      if (mappedValue != "Desconocido") {
        updateData['scope'] = mappedValue;
      } else {
        print(" Advertencia: No se pudo mapear el valor '$scope'");
      }
    }

    if (isActive != null) {
      updateData['is_active'] = isActive;
    }

    // 3. Limpieza de URL (Elimina espacios y posibles slashes dobles)
    final String cleanId = userId.trim().replaceAll('/', '');
    final String cleanPath = "/auth/users/$cleanId";

    print("🚀 Enviando PATCH a: $cleanPath");
    print("📦 Body: $updateData");

    try {
      final response = await dio.patch(cleanPath, data: updateData);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      // Log detallado para ver por qué falla el servidor
      print(" Error en Servidor: ${e.response?.statusCode} - ${e.response?.data}");
      rethrow;
    }
  }

  @override
  Future<Unit> deleteUser(String userId) async {
    await dio.patch("/auth/$userId/deactivate");
    return unit;
  }

  @override
  Future<Unit> activateUser(String userId) async {
    await dio.patch("/auth/$userId/activate");
    return unit;
  }
}