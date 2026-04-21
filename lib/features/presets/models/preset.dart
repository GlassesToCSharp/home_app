import 'package:home_app/services/database_service/database_service.dart';
import 'package:home_app/services/database_service/models/database_entry.dart';
import 'package:json_annotation/json_annotation.dart';

export 'package:home_app/models/node_device_status.dart';

part 'preset.g.dart';

// Don't forget to run:
// dart run build_runner build --delete-conflicting-outputs

@JsonSerializable()
class Preset extends DatabaseEntry<Preset> {
  // Table name and ID column are accessed elsewhere for linking DB items.
  static const String tableName = "presets";
  static const String colId = "id";
  static const String _colName = "name";

  @JsonKey(name: colId)
  final int id;
  @JsonKey(name: _colName)
  final String name;

  @override
  List<Object?> get props => [id, name];

  const Preset({required this.id, required this.name});

  // Empty instance for using the "getAll" method.
  factory Preset.instance() {
    return Preset(id: 0, name: "");
  }

  @override
  Map<String, Object?> toJson() => _$PresetToJson(this);

  factory Preset.fromJson(Map<String, Object?> json) => _$PresetFromJson(json);

  static String databaseTableCreation() {
    return "CREATE TABLE IF NOT EXISTS $tableName("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$_colName VARCHAR(29))";
  }

  @override
  Future<Preset> insert(DatabaseService dbService) {
    final entry = toJson();
    entry.remove(colId);
    return dbService.insert(tableName, entry).then(Preset.fromJson);
  }

  @override
  Future<List<Preset>> getAll(DatabaseService dbService) {
    return dbService.getAll(tableName, Preset.fromJson);
  }

  @override
  Future<Preset> udpate(DatabaseService dbService) {
    return dbService.update(tableName, toJson()).then((_) => this);
  }

  @override
  Future<void> delete(DatabaseService dbService) {
    return dbService.delete(tableName, toJson());
  }
}
