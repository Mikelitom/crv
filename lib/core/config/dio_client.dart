import 'package:crv_reprosisa/core/network/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'environment.dart';

final refreshDioProvider = Provider<Dio>((ref) {
  final config = EnvironmentConfig.current;

  return Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final config = EnvironmentConfig.current;

  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  final refreshDio = ref.read(refreshDioProvider);

  dio.interceptors.add(
    AuthInterceptor(ref: ref, dio: dio, refreshDio: refreshDio),
  );

  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ),
  );

  return dio;
});
