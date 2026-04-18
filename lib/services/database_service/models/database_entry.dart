import 'package:equatable/equatable.dart';
import 'package:home_app/services/database_service/database_service.dart';

abstract class DatabaseEntry<T> extends Equatable {
  const DatabaseEntry();

  Future<T> insert(DatabaseService dbService);
  Future<List<T>> getAll(DatabaseService dbService);
  Future<T> udpate(DatabaseService dbService);
  Future<void> delete(DatabaseService dbService);
}
