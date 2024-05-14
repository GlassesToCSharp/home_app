import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'local_storage.dart';
part 'safe_storage.dart';

abstract class StorageService {
  Future<bool> hasData();
  Future<String> read(String key, {String defaultValue = ""});
  Future<Map<String, String>> readAll();
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}
