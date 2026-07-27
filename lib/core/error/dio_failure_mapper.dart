import 'package:dio/dio.dart';
import 'failure.dart';

Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure(
        "No fue posible conectar con el servidor",
      );

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
          return BadRequestFailure(
            e.response?.data['detail']?.toString() ??
                "Solicitud inválida",
          );

        case 401:
          final path = e.requestOptions.path;

          if (path.contains('/auth/login')) {
            return const InvalidCredentialsFailure();
          }

          return const SessionExpiredFailure();

        case 403:
          return const UnauthorizedFailure();

        case 500:
          return const ServerFailure(
            "Error interno del servidor",
          );

        default:
          return ServerFailure(
            e.response?.data.toString() ??
                "Ocurrió un error inesperado",
          );
      }

    default:
      return UnknownFailure(
        e.message ?? "Error desconocido",
      );
  }
}