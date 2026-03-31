import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/dio_client.dart';
import '../../data/datasource/catalogo_remote_datasource_impl.dart';
import '../../data/repositories/catalogo_repository_impl.dart';
import '../../domain/repositories/catalogo_repositories.dart';
import '../../domain/usecases/get_vehicles_use_cases.dart';
import '../../domain/usecases/get_presses_use_case.dart';
import '../../domain/usecases/update_vehicle_status_use_case.dart';

final catalogoRemoteDataSourceProvider = Provider((ref) => 
  CatalogoRemoteDataSourceImpl(ref.read(dioProvider)));

final catalogoRepositoryProvider = Provider<CatalogoRepository>((ref) => 
  CatalogoRepositoryImpl(ref.read(catalogoRemoteDataSourceProvider)));

final getVehiclesUseCaseProvider = Provider((ref) => 
  GetVehiclesUseCase(ref.read(catalogoRepositoryProvider)));

final getPressesUseCaseProvider = Provider((ref) => 
  GetPressesUseCase(ref.read(catalogoRepositoryProvider)));

final updateVehicleStatusUseCaseProvider = Provider((ref) => 
  UpdateVehicleStatusUseCase(ref.read(catalogoRepositoryProvider)));