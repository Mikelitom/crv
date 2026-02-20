import 'dart:async';
import 'package:dio/dio.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../storage/token_storage.dart';

class DioClient {
  final Dio dio;
  final TokenStorage storage;
  final AuthRepository authRepository;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  DioClient({
    required this.storage,
    required this.authRepository,
  }) : dio = Dio(BaseOptions(baseUrl: "http://localhost:8000")) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final expiresAt = await storage.getExpiresAt();

          if (expiresAt != null &&
              DateTime.now().isAfter(expiresAt)) {
            await _refreshToken();
          }

          final token = await storage.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              await _refreshToken();

              final newToken = await storage.getAccessToken();
              error.requestOptions.headers["Authorization"] =
                  "Bearer $newToken";

              final clone = await dio.fetch(error.requestOptions);
              return handler.resolve(clone);
            } catch (_) {
              return handler.next(error);
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<void> _refreshToken() async {
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer();

    try {
      await authRepository.refresh();
      _refreshCompleter!.complete();
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }
} 