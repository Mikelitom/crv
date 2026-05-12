import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crv_reprosisa/features/auth/presentation/di/auth_providers.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;
  final Dio dio;
  final Dio refreshDio;

  AuthInterceptor({
    required this.ref,
    required this.dio,
    required this.refreshDio,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tokenRepository = ref.read(tokenRepositoryProvider);

    final tokens = await tokenRepository.get();

    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
  }
}
