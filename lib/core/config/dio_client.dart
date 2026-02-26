import 'package:crv_reprosisa/features/auth/presentation/di/auth_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'environment.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = EnvironmentConfig.current;

  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final tokenRepository = ref.read(tokenRepositoryProvider);

        final tokens = await tokenRepository.get();

        if (tokens != null) {
          options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
        }

        handler.next(options);
      },
    ),
  );

  return dio;
});
