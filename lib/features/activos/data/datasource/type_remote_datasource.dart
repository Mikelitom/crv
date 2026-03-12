import 'package:crv_reprosisa/features/activos/domain/entities/vehicle_type.dart';

abstract class TypeRemoteDatasource {
  Future<List<VehicleType>> getAllTypes();
}
