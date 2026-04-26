import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/services/database_service/database_service.dart';
import 'package:home_app/services/database_service/models/database_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preset_action.g.dart';

// Don't forget to run:
// dart run build_runner build --delete-conflicting-outputs

// Max enum name length - 30
@JsonEnum()
enum InstructionName {
  @JsonValue("power")
  power,
  @JsonValue("neonBrightness")
  neonBrightness,
  @JsonValue("ledColor")
  ledColor,
  @JsonValue("motorAcceleration")
  motorAcceleration,
  @JsonValue("motorSpeed")
  motorSpeed,
  @JsonValue("motorPosition")
  motorPosition,
}

@JsonSerializable()
class PresetAction extends DatabaseEntry<PresetAction> {
  // Table name and ID column are accessed elsewhere for linking DB items.
  static const String tableName = "presetActions";
  static const String colId = "id";
  static const String _colPresetId = "presetId";
  static const String _colDeviceId = "deviceId";
  static const String _colInstructionName = "instructionName";
  static const String _colInstructionValue = "instructionValue";

  @JsonKey(name: colId)
  final int id;
  @JsonKey(name: _colPresetId)
  final int presetId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Preset? preset;
  @JsonKey(name: _colDeviceId)
  final int deviceId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MyDevice? device;
  @JsonKey(name: _colInstructionName)
  final InstructionName instructionName;
  @JsonKey(name: _colInstructionValue)
  final int instructionValue;

  @override
  List<Object?> get props => [
    id,
    presetId,
    preset,
    deviceId,
    device,
    instructionName,
    instructionValue,
  ];

  const PresetAction({
    required this.id,
    required this.presetId,
    this.preset,
    required this.deviceId,
    this.device,
    required this.instructionName,
    required this.instructionValue,
  });

  @override
  Map<String, Object?> toJson() => _$PresetActionToJson(this);

  factory PresetAction.fromJson(Map<String, Object?> json) =>
      _$PresetActionFromJson(json);

  // Empty instance for using the "getAll" method.
  factory PresetAction.instance() {
    return PresetAction(
      id: 0,
      deviceId: 0,
      presetId: 0,
      // Doesn't matter the value here.
      instructionName: InstructionName.ledColor,
      instructionValue: 0,
    );
  }

  static String databaseTableCreation() {
    return "CREATE TABLE IF NOT EXISTS $tableName("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$_colPresetId INTEGER, "
        "$_colDeviceId INTEGER, "
        "$_colInstructionName VARCHAR(255), "
        "$_colInstructionValue INTEGER, "
        "FOREIGN KEY ($_colPresetId) REFERENCES ${Preset.tableName}(${Preset.colId}, "
        "FOREIGN KEY ($_colDeviceId) REFERENCES ${MyDevice.tableName}(${MyDevice.colId}, ) "
        "ON DELETE NO ACTION ON UPDATE NO ACTION)";
  }

  Future<PresetAction> withFetchedPreset(DatabaseService dbService) async {
    return PresetAction(
      id: id,
      deviceId: deviceId,
      device: device,
      presetId: presetId,
      preset: await Preset.instance().getById(dbService, presetId),
      instructionName: instructionName,
      instructionValue: instructionValue,
    );
  }

  Future<PresetAction> withFetchedDevice(DatabaseService dbService) async {
    return PresetAction(
      id: id,
      deviceId: deviceId,
      device: await MyDevice.instance().getById(dbService, deviceId),
      presetId: presetId,
      preset: preset,
      instructionName: instructionName,
      instructionValue: instructionValue,
    );
  }

  @override
  Future<PresetAction> insert(DatabaseService dbService) async {
    final entry = toJson();
    entry.remove(colId);
    return dbService
        .insert(tableName, entry)
        .then(PresetAction.fromJson)
        .then(
          (pa) => pa
              .withFetchedDevice(dbService)
              .then((pa) => pa.withFetchedPreset(dbService)),
        );
  }

  @override
  Future<List<PresetAction>> getAll(
    DatabaseService dbService, {
    String? whereClause,
    List<Object?>? whereArgs,
  }) {
    if (whereClause == null) {
      return dbService.getAll(tableName, PresetAction.fromJson);
    }

    return dbService.getAll(
      tableName,
      PresetAction.fromJson,
      whereClause: whereClause,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<PresetAction> getById(
    DatabaseService dbService,
    int id, {
    String columnIdentifier = colId,
  }) {
    return dbService
        .getAll(
          tableName,
          PresetAction.fromJson,
          whereClause: "$columnIdentifier = ?",
          whereArgs: [id],
        )
        .then((presetActions) {
          switch (presetActions.length) {
            case 0:
              throw "No preset actions found";
            case 1:
              return presetActions.first;
            default:
              throw "Too many preset actions with ID $id";
          }
        });
  }

  @override
  Future<PresetAction> udpate(DatabaseService dbService) {
    return dbService
        .update(tableName, toJson())
        .then((_) => this)
        .then(
          (pa) => pa
              .withFetchedDevice(dbService)
              .then((pa) => pa.withFetchedPreset(dbService)),
        );
  }

  @override
  Future<void> delete(DatabaseService dbService) {
    return dbService.delete(tableName, toJson());
  }
}
