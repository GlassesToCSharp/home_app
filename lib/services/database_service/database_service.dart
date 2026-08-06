import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'live_database_service.dart';
part 'mock_database_service.dart';

abstract class DatabaseService {
  bool get isInitialised;

  const DatabaseService();

  Future<void> initialiseDatabase();
  Future<Map<String, Object?>> insert(
    String tableName,
    Map<String, Object?> object,
  );
  Future<List<T>> getAll<T>(
    String tableName,
    T Function(Map<String, Object?>) converter, {
    String? whereColIdName,
    int? whereColIdValue,
  });
  Future<int> update(
    String tableName,
    Map<String, Object?> model, [
    String identifyingColumnName = "id",
  ]);
  Future<void> delete(
    String tableName,
    Map<String, Object?> model, [
    String identifyingColumnName = "id",
  ]);
}
