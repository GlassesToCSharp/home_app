part of 'database_service.dart';

class LiveDatabaseService extends DatabaseService {
  late Database _db;

  LiveDatabaseService();

  @override
  Future<void> initialiseDatabase() async {
    // Open the database and store the reference.
    _db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), "local_database.db"),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        // TODO: Does it need to run here, or can it be run later? Need to
        // remove the dependency to other classes.
        return db.execute(MyDevice.databaseTableCreation());
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  @override
  Future<Map<String, Object?>> insert(
    String tableName,
    Map<String, Object?> object, [
    String identifyingColumnName = "id",
  ]) async {
    final newId = await _db.insert(
      tableName,
      object,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (newId != 0) {
      object[identifyingColumnName] = newId;
      return object;
    }

    throw "Failed to insert model into $tableName";
  }

  @override
  Future<List<T>> getAll<T>(
    String tableName,
    T Function(Map<String, Object?>) converter,
  ) async {
    // Query the table for all objects. {SELECT * FROM tableName}
    final result = await _db.query(tableName);

    // Convert the List<Map<String, Object?> into a List<T>.
    return result.map(converter).toList();
  }

  @override
  Future<int> update(
    String tableName,
    Map<String, Object?> model, [
    String identifyingColumnName = "id",
  ]) async {
    var res = await _db.update(
      tableName,
      model,
      // Ensure that the object has an identifying column name (default: id).
      where: '$identifyingColumnName = ?',
      // Pass the object's value as a whereArg to prevent SQL injection.
      whereArgs: [model[identifyingColumnName]],
    );
    return res;
  }

  @override
  Future<void> delete(
    String tableName,
    Map<String, Object?> model, [
    String identifyingColumnName = "id",
  ]) async {
    try {
      await _db.delete(
        tableName,
        // Use a `where` clause to delete a specific object.
        where: "$identifyingColumnName = ?",
        // Pass the object's value as a whereArg to prevent SQL injection.
        whereArgs: [model[identifyingColumnName]],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
