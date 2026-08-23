part of 'database_service.dart';

class LiveDatabaseService extends DatabaseService {
  Database? _db;

  @override
  bool get isInitialised => _db != null;

  LiveDatabaseService();

  @override
  Future<void> initialiseDatabase() async {
    // Open the database and store the reference.
    _db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), "local_database.db"),
      // As we are using Foreign Keys to link entries between different tables,
      // we need to enable this.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        // TODO: Does it need to run here, or can it be run later? Need to
        // remove the dependency to other classes.
        await db.execute(MyDevice.databaseTableCreation());
        await db.execute(Preset.databaseTableCreation());
        await db.execute(PresetAction.databaseTableCreation());
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
    if (!isInitialised) {
      await initialiseDatabase();
    }

    final newId = await _db!.insert(
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
    T Function(Map<String, Object?>) converter, {
    String? whereColIdName,
    int? whereColIdValue,
  }) async {
    if (!isInitialised) {
      await initialiseDatabase();
    }

    if ((whereColIdName != null && whereColIdValue == null) ||
        (whereColIdName == null && whereColIdValue != null)) {
      throw "If 'where' arguments are passed, both the clause and the arguments must not be null.";
    }

    final result = <Map<String, Object?>>[];

    // Query the table for all objects. {SELECT * FROM tableName}
    if (whereColIdName == null) {
      result.addAll(await _db!.query(tableName));
    } else {
      result.addAll(
        await _db!.query(
          tableName,
          where: "$whereColIdName = ?",
          whereArgs: [whereColIdValue],
        ),
      );
    }

    // Convert the List<Map<String, Object?> into a List<T>.
    return result.map(converter).toList();
  }

  @override
  Future<int> update(
    String tableName,
    Map<String, Object?> model, [
    String identifyingColumnName = "id",
  ]) async {
    if (!isInitialised) {
      await initialiseDatabase();
    }

    var res = await _db!.update(
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
    if (!isInitialised) {
      await initialiseDatabase();
    }

    try {
      await _db!.delete(
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
