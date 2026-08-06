import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/services/database_service/database_service.dart';
import 'package:home_app/services/database_service/models/database_entry.dart';
import 'package:json_annotation/json_annotation.dart';

export 'package:home_app/features/devices/models/device.dart';

part 'my_device.g.dart';

// Don't forget to run:
// dart run build_runner build --delete-conflicting-outputs

@JsonSerializable()
class MyDevice extends DatabaseEntry<MyDevice> {
  // Table name and ID column are accessed elsewhere for linking DB items.
  static const String tableName = "myDevices";
  static const String colId = "id";
  static const String _colDeviceId = "deviceId";
  static const String _colName = "name";
  static const String _colIpAddress = "ipAddress";

  @JsonKey(name: colId)
  final int id;
  @JsonKey(name: _colDeviceId)
  final String deviceId;
  @JsonKey(name: _colName)
  final String name;
  @JsonKey(name: _colIpAddress)
  final String ipAddress;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Device? device;

  @override
  List<Object?> get props => [id, deviceId, name, ipAddress];

  const MyDevice({
    required this.id,
    required this.deviceId,
    required this.name,
    required this.ipAddress,
    this.device = null,
  });

  factory MyDevice.fromDevice(Device device) {
    return MyDevice(
      id: 0,
      deviceId: device.nodeDeviceStatus.id,
      name: device.nodeDeviceStatus.name,
      ipAddress: device.ipAddress,
      device: device,
    );
  }

  // Empty instance for using the "getAll" method.
  factory MyDevice.instance() {
    return MyDevice(id: 0, deviceId: "", name: "", ipAddress: "");
  }

  Device toDevice() {
    if (device != null) {
      return device!;
    }

    return Device(
      ipAddress: ipAddress,
      nodeDeviceStatus: NodeDeviceStatus.empty().copyWith(
        id: deviceId,
        name: name,
      ),
    );
  }

  MyDevice withDevice(Device device) {
    return MyDevice(
      id: id,
      deviceId: deviceId,
      name: name,
      ipAddress: ipAddress,
      device: device,
    );
  }

  MyDevice copyWith({
    int? id,
    String? deviceId,
    String? name,
    String? ipAddress,
    Device? device,
  }) {
    return MyDevice(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      device: device ?? this.device,
    );
  }

  @override
  Map<String, Object?> toJson() => _$MyDeviceToJson(this);

  factory MyDevice.fromJson(Map<String, Object?> json) =>
      _$MyDeviceFromJson(json);

  static String databaseTableCreation() {
    return "CREATE TABLE IF NOT EXISTS $tableName("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$_colDeviceId VARCHAR(3), "
        "$_colName VARCHAR(19), "
        "$_colIpAddress VARCHAR(15))";
  }

  @override
  Future<MyDevice> insert(DatabaseService dbService) {
    final entry = toJson();
    entry.remove(colId);
    return dbService
        .insert(tableName, entry)
        .then(
          (newDbObject) =>
              MyDevice.fromJson(newDbObject).copyWith(device: device),
        );
  }

  @override
  Future<List<MyDevice>> getAll(
    DatabaseService dbService, {
    String? whereColIdName,
    int? whereColIdValue,
  }) {
    return dbService.getAll(
      tableName,
      MyDevice.fromJson,
      whereColIdName: whereColIdName,
      whereColIdValue: whereColIdValue,
    );
  }

  @override
  Future<MyDevice> getById(
    DatabaseService dbService,
    int id, {
    String columnIdentifier = colId,
  }) {
    return dbService
        .getAll(
          tableName,
          MyDevice.fromJson,
          whereColIdName: columnIdentifier,
          whereColIdValue: id,
        )
        .then((myDevices) {
          switch (myDevices.length) {
            case 0:
              throw "No devices found";
            case 1:
              return myDevices.first;
            default:
              throw "Too many devices with ID $id";
          }
        });
  }

  @override
  Future<MyDevice> udpate(DatabaseService dbService) {
    return dbService.update(tableName, toJson()).then((_) => this);
  }

  @override
  Future<void> delete(DatabaseService dbService) {
    return dbService.delete(tableName, toJson());
  }
}
