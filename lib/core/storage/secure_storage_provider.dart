
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final keyValueStorageServiceProvider = Provider<KeyValueStorageService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return KeyValueStorageServiceImpl(secureStorage);
});

abstract class KeyValueStorageService {
  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey(String key);
}

class KeyValueStorageServiceImpl implements KeyValueStorageService {
  final FlutterSecureStorage _storage;
  KeyValueStorageServiceImpl(this._storage);

  @override
  Future<T?> getValue<T>(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return value as T;
  }

  @override
  Future<bool> removeKey(String key) async {
    await _storage.delete(key: key);
    return true;
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    await _storage.write(key: key, value: value.toString());
  }
}