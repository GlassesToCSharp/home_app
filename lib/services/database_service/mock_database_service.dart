part of 'database_service.dart';

class MockDatabaseService extends DatabaseService {
  static const Duration _mockDelay = Duration(milliseconds: 500);

  final _dbDictionary = <String, List<Map<String, Object?>>>{};

  @override
  Future<void> initialiseDatabase() {
    _dbDictionary["myDevices"] = List<Map<String, Object?>>.empty();
    return Future.delayed(const Duration());
  }

  @override
  Future<Map<String, Object?>> insert(
    String tableName,
    Map<String, Object?> object, [
    String identifyingColumnName = "id",
  ]) {
    object[identifyingColumnName] = _dbDictionary[tableName]?.length ?? 0;
    _dbDictionary[tableName]?.add(object);
    return Future.delayed(_mockDelay);
  }

  @override
  Future<List<T>> getAll<T>(
    String tableName,
    T Function(Map<String, Object?>) converter,
  ) {
    return Future.delayed(
      _mockDelay,
      () => _dbDictionary[tableName]!,
    ).then((listResult) => listResult.map(converter).toList());
  }

  @override
  Future<int> update(
    String tableName,
    Map<String, Object?> model, [
    String identifyingColumnName = "id",
  ]) {
    final list = _dbDictionary[tableName]!;
    final index = list.indexWhere(
      (m) => m[identifyingColumnName] == model[identifyingColumnName],
    );
    list[index] = model;
    _dbDictionary[tableName] = list;
    return Future.delayed(_mockDelay, () => 1);
  }

  @override
  Future<void> delete(
    String tableName,
    Map<String, Object?> model, [
    String identifyingColumnName = "id",
  ]) {
    final list = _dbDictionary[tableName]!;
    list.removeWhere(
      (m) => m[identifyingColumnName] == model[identifyingColumnName],
    );
    return Future.delayed(_mockDelay);
  }
}
