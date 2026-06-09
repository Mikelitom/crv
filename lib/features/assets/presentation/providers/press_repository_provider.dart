import 'package:crv_reprosisa/features/assets/data/repositories/press_repository_impl.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/provider/inspeccion_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_remote_datasource_provider.dart';

final pressRepositoryProvider = Provider<PressRepository>((ref) {
  final datasource = ref.read(pressRemoteDatasourceProvider);
  final local = ref.read(inspectionLocalDataSourceProvider);
  return PressRepositoryImpl(datasource, local);
});
