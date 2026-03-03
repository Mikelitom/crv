import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/press/press_loans_model.dart';
import 'package:crv_reprosisa/data/repositories/press/press_loans_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/press/press_loans.dart';
import 'package:crv_reprosisa/domain/repositories/press/press_loans_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pressLoansDataSourceProvider = Provider<BaseDataSource<PressLoans>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/loans", 
    fromJson: PressLoansModel.fromJson,
  );
});

final pressLoansRepositoryProvider = Provider<PressLoansReposity>((ref) {
  final dataSource = ref.read(pressLoansDataSourceProvider);
  return PressLoansRepositoryImpl(dataSource);
});