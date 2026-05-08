import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/banda_remote_datasource.dart';
import '../../data/repositories/banda_repository_impl.dart';
import '../../domain/repositories/banda_repository.dart';
import '../../domain/usecases/get_banda_template_use_case.dart';
import '../../domain/usecases/get_active_clients_use_case.dart';
import '../../domain/usecases/get_active_mines_use_case.dart';
import '../../domain/usecases/create_banda_report_use_case.dart';
import '../notifier/banda_inspection_notifier.dart';
import 'banda_inspection_state.dart';
import '../../../../core/config/dio_client.dart';

// Data Source & Repo
final bandaDataSourceProvider = Provider((ref) => BandaRemoteDataSourceImpl(ref.watch(dioProvider)));
final bandaRepositoryProvider = Provider<BandaRepository>((ref) => BandaRepositoryImpl(ref.watch(bandaDataSourceProvider)));

// Use Cases
final getBandaTemplateUseCaseProvider = Provider((ref) => GetBandaTemplateUseCase(ref.watch(bandaRepositoryProvider)));
final getActiveClientsUseCaseProvider = Provider((ref) => GetActiveClientsUseCase(ref.watch(bandaRepositoryProvider)));
final getActiveMinesUseCaseProvider = Provider((ref) => GetActiveMinesUseCase(ref.watch(bandaRepositoryProvider)));

// ESTE ES EL PROVIDER QUE TE FALTABA
final createBandaReportUseCaseProvider = Provider((ref) => CreateBandaReportUseCase(ref.watch(bandaRepositoryProvider)));

// Notifier Principal
final bandaInspectionProvider = NotifierProvider<BandaInspectionNotifier, BandaInspectionState>(() {
  return BandaInspectionNotifier();
});