import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/activos/data/datasource/press_remote_datasource.dart';
import 'package:crv_reprosisa/features/activos/data/datasource/press_remote_datasource_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientRemoteDatasourceProvider = Provider<PressRemoteDatasource>((ref) {
  final dio = ref.read(dioProvider);

  return PressRemoteDatasourceImpl(dio);
});
