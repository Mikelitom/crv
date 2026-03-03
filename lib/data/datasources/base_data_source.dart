import 'dart:async';

abstract class BaseDataSource<T> {
  Future<List<T>> getAll();
  Future<T> getById(String id);
  Future<void> create(T data);
  Future<void> update(T data);
  Future<void> delete(String id);
  Future<List<T>> getByAttribute(String attr, String value);
  Future<List<T>> search(String query);
}