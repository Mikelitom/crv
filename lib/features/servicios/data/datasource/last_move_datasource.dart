import 'package:crv_reprosisa/features/servicios/data/models/last_movements_model.dart';
import 'package:dio/dio.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardLastMovements> getLastMovements();
}

class DashboardRemoteDataSourceImpl
    implements DashboardRemoteDataSource {

  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<DashboardLastMovements> getLastMovements() async {
    final response = await dio.get(
      "/asset/last-movements",
    );

    return DashboardLastMovements.fromJson(response.data);
  }
}