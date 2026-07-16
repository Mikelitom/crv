import 'dart:typed_data';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_press_report_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final Dio dio;

  ReportsNotifier({
    required this.getAllReportsUseCase,
    required this.getVehicleDetail,
    required this.getPressDetail,
    required this.getConveyorDetail,
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
    
    // Acceso seguro a la propiedad 'tipo' del reporte
    final filtered = state.allReports.where((r) {
      final dynamic report = r;
      return report.tipo.toString().toUpperCase() == tipoBuscado;
    }).toList();
    
    state = state.copyWith(filteredReports: filtered);
  }

  /// Carga inicial de todos los reportes
  Future<void> loadAllReports() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await getAllReportsUseCase.execute();
      final combined = [
        ...data['vehicles'] ?? [],
        ...data['conveyors'] ?? [],
        ...data['presses'] ?? []
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

      // 1. Obtención de detalle según el tipo de reporte
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

      // 2. Validación de datos obtenidos
      if (detail == null) {
        throw Exception("No se pudo obtener el detalle del reporte para el ID: $id");
      }

      // 3. Delegación al Coordinador de PDF
      final bytes = await PdfReportCoordinator.generate(dio, detail, tipo);
      
      state = state.copyWith(isLoading: false);
      return bytes;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }
}