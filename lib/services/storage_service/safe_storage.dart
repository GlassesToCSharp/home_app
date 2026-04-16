part of 'storage_service.dart';

class SafeStorage extends StorageService {
  static const _androidOptions = AndroidOptions();

  final FlutterSecureStorage _storage;

  SafeStorage()
    : _storage = const FlutterSecureStorage(aOptions: _androidOptions);

  @override
  Future<String> read(String key, {String defaultValue = ""}) async {
    return await _storage.read(key: key) ?? defaultValue;
  }

  @override
  Future<Map<String, String>> readAll() {
    return _storage.readAll();
  }

  @override
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  @override
  Future<bool> hasData() {
    return readAll().then((value) => value.isNotEmpty);
  }
}
