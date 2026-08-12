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

enum PresetActionState { idle, executing, failed, success }

@JsonSerializable()
class PresetAction extends DatabaseEntry<PresetAction> {
  // Table name and ID column are accessed elsewhere for linking DB items.
  static const String tableName = "presetActions";
  static const String colId = "id";
  static const String colPresetId = "presetId";
  static const String _colDeviceId = "deviceId";
  static const String _colInstructionName = "instructionName";
  static const String _colInstructionValue = "instructionValue";

  @JsonKey(name: colId)
  final int id;
  @JsonKey(name: colPresetId)
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
  @JsonKey(includeFromJson: false, includeToJson: false)
  final PresetActionState presetActionState;

  @override
  List<Object?> get props => [
    id,
    presetId,
    preset,
    deviceId,
    device,
    instructionName,
    instructionValue,
    presetActionState,
  ];

  const PresetAction({
    required this.id,
    required this.presetId,
    this.preset,
    required this.deviceId,
    this.device,
    required this.instructionName,
    required this.instructionValue,
    this.presetActionState = PresetActionState.idle,
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

  // Empty instance for using the "getAll" method.
  Future<PresetAction> copyWith(
    DatabaseService dbService, {
    int? id,
    int? presetId,
    int? deviceId,
    InstructionName? instructionName,
    int? instructionValue,
    PresetActionState? presetActionState,
  }) async {
    MyDevice? device;
    if (deviceId != null && deviceId != this.deviceId) {
      device = await MyDevice.instance().getById(dbService, deviceId);
    }
    Preset? preset;
    if (presetId != null && presetId != this.presetId) {
      preset = await Preset.instance().getById(dbService, presetId);
    }
    return PresetAction(
      id: id ?? this.id,
      presetId: presetId ?? this.presetId,
      preset: preset ?? this.preset,
      deviceId: deviceId ?? this.deviceId,
      device: device ?? this.device,
      instructionName: instructionName ?? this.instructionName,
      instructionValue: instructionValue ?? this.instructionValue,
      presetActionState: presetActionState ?? this.presetActionState,
    );
  }

  static String databaseTableCreation() {
    return "CREATE TABLE IF NOT EXISTS $tableName("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colPresetId INTEGER, "
        "$_colDeviceId INTEGER, "
        "$_colInstructionName VARCHAR(255), "
        "$_colInstructionValue INTEGER, "
        "FOREIGN KEY ($colPresetId) REFERENCES ${Preset.tableName}(${Preset.colId}) "
        "ON DELETE CASCADE ON UPDATE NO ACTION, "
        "FOREIGN KEY ($_colDeviceId) REFERENCES ${MyDevice.tableName}(${MyDevice.colId}) "
        "ON DELETE CASCADE ON UPDATE NO ACTION)";
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
    String? whereColIdName,
    int? whereColIdValue,
  }) {
    if (whereColIdName == null) {
      return dbService.getAll(tableName, PresetAction.fromJson);
    }

    return dbService
        .getAll(
          tableName,
          PresetAction.fromJson,
          whereColIdName: whereColIdName,
          whereColIdValue: whereColIdValue,
        )
        .then((presetActions) async {
          for (int i = 0; i < presetActions.length; i++) {
            final presetAction = await presetActions[i]
                .withFetchedDevice(dbService)
                .then((pa) => pa.withFetchedPreset(dbService));
            presetActions[i] = presetAction;
          }
          return presetActions;
        });
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
          whereColIdName: columnIdentifier,
          whereColIdValue: id,
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
