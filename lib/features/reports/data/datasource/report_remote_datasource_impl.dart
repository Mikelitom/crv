import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../models/vehicle_history_model.dart';
import '../models/conveyor_history_model.dart';
import '../models/press_history_model.dart';
import 'report_remote_datasource.dart';

class ReportRemoteDatasourceImpl implements ReportRemoteDatasource {
  final Dio dio;

  ReportRemoteDatasourceImpl(this.dio);

  @override
  Future<List<VehicleHistoryModel>> getVehicleHistory() async {
    final response = await dio.get('/asset/vehicle-history');
    final List<dynamic> data = response.data;
    return data.map((json) => VehicleHistoryModel.fromJson(json)).toList();
  }

  @override
  Future<void> sendConveyorReviewNote(String versionId, String notes) async {
    final response = await dio.post(
      '/review-notes/conveyor/report/$versionId',
      data: {'notes': notes},
    );

    if (response.statusCode == 201) {
      return;
    }
  }

  @override
  Future<List<ConveyorHistoryModel>> getConveyorHistory() async {
    final response = await dio.get('/asset/client-history');
    final List<dynamic> data = response.data;
    return data.map((json) => ConveyorHistoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<PressHistoryModel>> getPressHistory() async {
    final response = await dio.get('/asset/press-history');
    final List<dynamic> data = response.data;
    return data.map((json) => PressHistoryModel.fromJson(json)).toList();
  }
@override
  Future<List<String>> getClientEmails(String clientId) async {
    try {
      final response = await dio.get('/asset/clients/$clientId/contact');
      // La respuesta viene directamente como una lista de strings: ["correo1@mail.com", "correo2@mail.com"]
      final List<dynamic> data = response.data;
      return data.map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? "Error al obtener los correos del cliente");
    }
  }
 @override
  Future<void> sendReportEmail({
    required String versionId,
    required String email, // Puede ser un correo o varios separados por comas según tu API
    required String message,
    required Uint8List pdfBytes,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'email': email,
        'message': message,
        'pdf': MultipartFile.fromBytes(
          pdfBytes,
          filename: 'reporte_inspeccion.pdf',
        ),
      });

      await dio.post(
        '/asset/reports/$versionId/send-email',
        data: formData,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? "Error al enviar el reporte por correo");
    }
  }
  @override
  Future<void> acceptReport(String reportId) async {
    try {
      final response = await dio.patch(
        '/full-conveyor-reports/$reportId/accept',
      );

      if (response.statusCode != 200) {
        throw Exception("Error al aceptar el reporte: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? "Error de conexión");
    }
  }
}
