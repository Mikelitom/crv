import 'dart:typed_data';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_press_report_detail.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/accept_report_usecase.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/get_client_emauls_usecase.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/get_pending_reports_usecase.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/send_conveyor_note_usecase.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/send_report_email_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/get_all_reports_usecae.dart';
import 'package:crv_reprosisa/features/reports/presentation/provider/reports_state.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_vehicle_report_detail.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_conveyor_report_detail_usecase.dart';
import 'package:crv_reprosisa/core/utils/report_pdf_coordinator.dart';

class ReportsNotifier extends StateNotifier<ReportsState> {
  final GetAllReportsUseCase getAllReportsUseCase;
  final GetVehicleReportDetail getVehicleDetail;
  final GetPressReportDetailUseCase getPressDetail;
  final GetConveyorReportDetailUseCase getConveyorDetail;
  final SendConveyorNoteUseCase sendConveyorNoteUseCase;
  final AcceptConveyorReportUseCase acceptConveyorReportUseCase;
  final GetPendingReportsUsecase pendingReportsUsecase;
  final GetClientEmailsUseCase getClientEmailsUseCase;
  final SendReportEmailUseCase sendReportEmailUseCase;
  final Dio dio;

  ReportsNotifier({
    required this.getAllReportsUseCase,
    required this.getVehicleDetail,
    required this.getPressDetail,
    required this.getConveyorDetail,
    required this.sendConveyorNoteUseCase,
    required this.acceptConveyorReportUseCase,
    required this.pendingReportsUsecase,
    required this.getClientEmailsUseCase,
    required this.sendReportEmailUseCase,
    required this.dio,
  }) : super(const ReportsState());

  /// Cambia de pestaña y filtra automáticamente
  void changeTab(int index) {
    state = state.copyWith(activeTabIndex: index);
    filterReports();
  }

  /// Filtra los reportes según la pestaña activa
  void filterReports() {
    final tipos = ["BANDA", "VEHICULO", "PRENSA"];
    final tipoBuscado = tipos[state.activeTabIndex];

    final filtered = state.allReports.where((r) {
      final dynamic report = r;
      return report.tipo.toString().toUpperCase() == tipoBuscado;
    }).toList();

    state = state.copyWith(filteredReports: filtered);
  }

  /// Acepta y marca el reporte como COMPLETED
  Future<void> acceptReport(String reportId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await acceptConveyorReportUseCase.call(reportId);
      await loadAllReports();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Error al aceptar reporte: ${e.toString()}",
      );
    }
  }

  Future<void> sendNote(String versionId, String notes) async {
    state = state.copyWith(isLoading: true);
    try {
      await sendConveyorNoteUseCase.call(versionId, notes);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> pendingReports() async {
    state = state.copyWith(isLoading: true);
    try {
      final reports = await pendingReportsUsecase.execute();
      state = state.copyWith(isLoading: false, pendingReports: reports);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Carga los correos del cliente directamente sin alterar el estado global para evitar congelamientos en la UI
  Future<List<String>> fetchClientEmails(String clientId) async {
    final result = await getClientEmailsUseCase(clientId);
    
    return result.fold(
      (failure) => [],
      (emails) => emails,
    );
  }

  /// Envía el reporte por correo con el PDF adjunto
  Future<bool> sendReportByEmail({
    required String versionId,
    required String email,
    required String message,
    required Uint8List pdfBytes,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await sendReportEmailUseCase(
      versionId: versionId,
      email: email,
      message: message,
      pdfBytes: pdfBytes,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  /// Carga inicial de todos los reportes
  Future<void> loadAllReports() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await getAllReportsUseCase.execute();
      final combined = [
        ...data['vehicles'] ?? [],
        ...data['conveyors'] ?? [],
        ...data['presses'] ?? [],
      ];
      state = state.copyWith(isLoading: false, allReports: combined);
      filterReports();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Orquestador para la generación del PDF
  Future<Uint8List?> generatePdfForReport(dynamic reportItem) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final String tipo = (reportItem as dynamic).tipo.toString().toUpperCase();
      final String id = (reportItem as dynamic).id.toString();
      dynamic detail;

      if (tipo == 'PRENSA') {
        final res = await getPressDetail.call(id);
        detail = res.fold((l) => null, (r) => r);
      } else if (tipo == 'VEHICULO') {
        final res = await getVehicleDetail.call(id);
        detail = res.fold((l) => null, (r) => r);
      } else if (tipo == 'BANDA') {
        final res = await getConveyorDetail.call(id);
        detail = res.fold((l) => null, (r) => r);
      }

      if (detail == null) {
        throw Exception("No se pudo obtener el detalle del reporte para el ID: $id");
      }

      final bytes = await PdfReportCoordinator.generate(dio, detail, tipo);
      state = state.copyWith(isLoading: false);
      return bytes;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }
}