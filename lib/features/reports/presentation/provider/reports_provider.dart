import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import 'package:crv_reprosisa/features/reports/data/datasource/report_remote_datasource.dart';
import 'package:crv_reprosisa/features/reports/data/datasource/report_remote_datasource_impl.dart';
import 'package:crv_reprosisa/features/reports/data/repository/report_repository_impl.dart';
import 'package:crv_reprosisa/features/reports/domain/repository/report_repository.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/accept_report_usecase.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/get_all_reports_usecae.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/get_client_emauls_usecase.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/get_pending_reports_usecase.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/send_conveyor_note_usecase.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/send_report_email_usecase.dart';
import 'package:crv_reprosisa/features/reports/presentation/notifier/reports_notifier.dart';
import 'package:crv_reprosisa/features/reports/presentation/provider/reports_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_usecase_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final reportRemoteDatasourceProvider = Provider<ReportRemoteDatasource>((ref) {
  return ReportRemoteDatasourceImpl(ref.read(dioProvider));
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(ref.read(reportRemoteDatasourceProvider));
});

final getAllReportsUseCaseProvider = Provider((ref) {
  return GetAllReportsUseCase(ref.read(reportRepositoryProvider));
});

final sendConveyorNoteUseCaseProvider = Provider((ref) {
  return SendConveyorNoteUseCase(ref.read(reportRepositoryProvider));
});

final acceptReportUseCaseProvider = Provider((ref) {
  return AcceptConveyorReportUseCase(ref.read(reportRepositoryProvider));
});

final getPendingReportsUseCaseProvider = Provider((ref) {
  return GetPendingReportsUsecase(ref.read(reportRepositoryProvider));
});

// Nuevos Providers de Casos de Uso para Correo
final getClientEmailsUseCaseProvider = Provider((ref) {
  return GetClientEmailsUseCase(ref.read(reportRepositoryProvider));
});

final sendReportEmailUseCaseProvider = Provider((ref) {
  return SendReportEmailUseCase(ref.read(reportRepositoryProvider));
});

final reportsNotifierProvider =
    StateNotifierProvider.autoDispose<ReportsNotifier, ReportsState>((ref) {
      final getAllReports = ref.read(getAllReportsUseCaseProvider);
      final sendNote = ref.read(sendConveyorNoteUseCaseProvider);
      final getVehicleDetail = ref.read(getVehicleReportDetailUseCaseProvider);
      final getPressDetail = ref.read(getPressReportDetailUseCaseProvider);
      final getConveyorDetail = ref.read(getConveyorReportDetailUseCaseProvider);
      final getAcceptReport = ref.read(acceptReportUseCaseProvider);
      final getPendingReport = ref.read(getPendingReportsUseCaseProvider);
      
      // Instancias de los nuevos casos de uso
      final getClientEmails = ref.read(getClientEmailsUseCaseProvider);
      final sendReportEmail = ref.read(sendReportEmailUseCaseProvider);
      
      final dio = ref.read(dioProvider);

      return ReportsNotifier(
        getAllReportsUseCase: getAllReports,
        sendConveyorNoteUseCase: sendNote,
        getVehicleDetail: getVehicleDetail,
        getPressDetail: getPressDetail,
        getConveyorDetail: getConveyorDetail,
        acceptConveyorReportUseCase: getAcceptReport,
        pendingReportsUsecase: getPendingReport,
        getClientEmailsUseCase: getClientEmails,
        sendReportEmailUseCase: sendReportEmail,
        dio: dio,
      );
    });