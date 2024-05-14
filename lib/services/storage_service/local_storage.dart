part of 'storage_service.dart';

class LocalStorage extends StorageService {
  final Map<String, String> _localStorage = {};

  @override
  Future<String> read(String key, {String defaultValue = ""}) async {
    return _localStorage[key] ?? defaultValue;
  }

  @override
  Future<Map<String, String>> readAll() async {
    return _localStorage;
  }

  @override
  Future<void> write(String key, String value) async {
    _localStorage[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _localStorage.remove(key);
  }

  @override
  Future<bool> hasData() {
    return Future.value(_localStorage.isNotEmpty);
  }
}
