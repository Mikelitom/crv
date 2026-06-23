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
  
    final alreadyRetried = requestOptions.extra['retried'] == true;
  
    final isAuthRoute =
        requestOptions.path.contains('/auth/login') ||
        requestOptions.path.contains('/auth/refresh');
  
    if (err.response?.statusCode == 401 && !alreadyRetried && !isAuthRoute) {
      requestOptions.extra['retried'] = true;
  
      try {
        final tokenRepository = ref.read(tokenRepositoryProvider);
        final tokens = await tokenRepository.get();
  
        if (tokens == null) {
          return handler.reject(err);
        }
  
        final result = await ref.read(authRepositoryProvider).refreshToken();
  
        final newTokens = result.fold(
          (failure) => throw Exception('Refresh failed'),
          (tokens) => tokens,
        );
  
        await tokenRepository.save(newTokens);
  
        requestOptions.headers['Authorization'] =
            'Bearer ${newTokens.accessToken}';
  
        final response = await dio.fetch(requestOptions);
  
        return handler.resolve(response);
  
      } catch (e) {
        await ref.read(tokenRepositoryProvider).clear();
  
        return handler.reject(err);
      }
    }
  
    return handler.next(err);
  }
}
