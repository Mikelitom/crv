import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/dio_client.dart';
import '../../data/repositories/inspection_repository_impl.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../../data/datasource/inspection_remote_data_source.dart';
import '../notifier/inspection_notifier.dart';
import '../../domain/usecases/get_my_inspections.dart';
import 'inspection_state.dart';
import '../../domain/usecases/get_inspection_by_id_use_case.dart';

final inspectionDataSourceProvider = Provider((ref) => 
  InspectionRemoteDataSourceImpl(ref.watch(dioProvider)));
final getInspectionByIdUseCaseProvider = Provider((ref) => 

  GetInspectionByIdUseCase(ref.watch(inspectionRepositoryProvider)));

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) => 
  InspectionRepositoryImpl(ref.watch(inspectionDataSourceProvider)));

final getMyInspectionsUseCaseProvider = Provider((ref) => 
  GetMyInspectionsUseCase(ref.watch(inspectionRepositoryProvider)));

final inspectionProvider = NotifierProvider<InspectionNotifier, InspectionState>(() {
  return InspectionNotifier();

  
});