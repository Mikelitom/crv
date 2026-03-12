import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/activos/data/datasource/type_remote_datasource.dart';
import 'package:crv_reprosisa/features/activos/data/datasource/type_remote_datasource_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final typeRemoteDatasourceProvider = Provider<TypeRemoteDatasource>((ref) {
  final dio = ref.read(dioProvider);

  return TypeRemoteDatasourceImpl(dio);
});
