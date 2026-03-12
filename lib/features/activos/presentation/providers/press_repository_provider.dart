import 'package:crv_reprosisa/features/activos/data/repositories/press_repository_impl.dart';
import 'package:crv_reprosisa/features/activos/domain/repositories/press_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/press_remote_datasource_provider.dart';

final pressRepositoryProvider = Provider<PressRepository>((ref) {
  final datasource = ref.read(pressRemoteDatasourceProvider);
  return PressRepositoryImpl(datasource);
});
