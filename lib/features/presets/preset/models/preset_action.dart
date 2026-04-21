import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/services/database_service/database_service.dart';
import 'package:home_app/services/database_service/models/database_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preset_action.g.dart';

// Don't forget to run:
// dart run build_runner build --delete-conflicting-outputs

@JsonSerializable()
class PresetAction extends DatabaseEntry<PresetAction> {
  // Table name and ID column are accessed elsewhere for linking DB items.
  static const String tableName = "presets";
  static const String colId = "id";
  static const String _colPresetId = "presetId";
  static const String _colDeviceId = "deviceId";
  static const String _colDeviceInstruction = "deviceInstruction";

  @JsonKey(name: colId)
  final int id;
  @JsonKey(name: _colPresetId)
  final int presetId;
  @JsonKey(name: _colDeviceId)
  final int deviceId;
  @JsonKey(name: _colDeviceInstruction)
  final String deviceInstruction;

  @override
  List<Object?> get props => [id, presetId, deviceId, deviceInstruction];

  const PresetAction({
    required this.id,
    required this.presetId,
    required this.deviceId,
    required this.deviceInstruction,
  });

  @override
  Map<String, Object?> toJson() => _$PresetActionToJson(this);

  factory PresetAction.fromJson(Map<String, Object?> json) =>
      _$PresetActionFromJson(json);

  static String databaseTableCreation() {
    return "CREATE TABLE IF NOT EXISTS $tableName("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$_colPresetId INTEGER, "
        "$_colDeviceId INTEGER, "
        "$_colDeviceInstruction VARCHAR(255), "
        "FOREIGN KEY ($_colPresetId) REFERENCES ${Preset.tableName}(${Preset.colId}, "
        "FOREIGN KEY ($_colDeviceId) REFERENCES ${MyDevice.tableName}(${MyDevice.colId}, ) "
        "ON DELETE NO ACTION ON UPDATE NO ACTION)";
  }

  @override
  Future<PresetAction> insert(DatabaseService dbService) {
    final entry = toJson();
    entry.remove(colId);
    return dbService.insert(tableName, entry).then(PresetAction.fromJson);
  }

  @override
  Future<List<PresetAction>> getAll(
    DatabaseService dbService, [
    Preset? preset,
  ]) {
    if (preset == null) {
      return dbService.getAll(tableName, PresetAction.fromJson);
    }

    return dbService.getAll(
      tableName,
      PresetAction.fromJson,
      whereClause: "$_colPresetId = ?",
      whereArgs: [preset.id],
    );
  }

  @override
  Future<PresetAction> udpate(DatabaseService dbService) {
    return dbService.update(tableName, toJson()).then((_) => this);
  }

  @override
  Future<void> delete(DatabaseService dbService) {
    return dbService.delete(tableName, toJson());
  }
}
