import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/last_move_datasource.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/last_move_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/last_movement_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/last_move_usecase.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/last_movement_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/last_movement_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRemoteDataSourceProvider = Provider(
  (ref) => DashboardRemoteDataSourceImpl(
    ref.read(dioProvider),
  ),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepositoryImpl(
    ref.read(dashboardRemoteDataSourceProvider),
  ),
);

final getLastMovementsUseCaseProvider = Provider(
  (ref) => GetLastMovementsUseCase(
    ref.read(dashboardRepositoryProvider),
  ),
);

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);