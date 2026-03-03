import 'package:dio/dio.dart';
import 'base_data_source.dart';

/// Implementación genérica del DataSource utilizando Dio
class BaseDataSourceImpl<T> implements BaseDataSource<T> {
  final Dio dio;
  final String endpoint;
  final T Function(Map<String, dynamic>) fromJson;

  BaseDataSourceImpl({
    required this.dio,
    required this.endpoint,
    required this.fromJson,
  });

  @override
  Future<List<T>> getAll() async {
    final response = await dio.get(endpoint);
    return (response.data as List)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<T> getById(String id) async {
    final response = await dio.get('$endpoint/$id');
    return fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> create(T data) async {
    // Nota: Aquí se asume que el objeto tiene un método toJson()
    // Si no quieres BaseEntity, puedes usar (data as dynamic).toJson()
    await dio.post(endpoint, data: (data as dynamic).toJson());
  }

  @override
  Future<void> update(T data) async {
    final id = (data as dynamic).id;
    await dio.put('$endpoint/$id', data: (data as dynamic).toJson());
  }

  @override
  Future<void> delete(String id) async {
    await dio.delete('$endpoint/$id');
  }

  @override
  Future<List<T>> getByAttribute(String attr, String value) async {
    final response = await dio.get(endpoint, queryParameters: {attr: value});
    return (response.data as List)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<T>> search(String query) async {
    // Este método es clave para tu buscador y evitar el Right Overflow
    final response = await dio.get('$endpoint/search', queryParameters: {'q': query});
    return (response.data as List)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }
}