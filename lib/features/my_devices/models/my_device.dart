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
  static const String _tableName = "myDevices";
  static const String _colId = "id";
  static const String _colDeviceId = "deviceId";
  static const String _colName = "name";
  static const String _colIpAddress = "ipAddress";

  @JsonKey(name: _colId)
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
    );
  }

  // Empty instance for using the "getAll" method.
  factory MyDevice.instance() {
    return MyDevice(id: 0, deviceId: "", name: "", ipAddress: "");
  }

  Device toDevice() {
    return Device(
      ipAddress: ipAddress,
      nodeDeviceStatus: NodeDeviceStatus.empty(),
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

  Map<String, Object?> toJson() => _$MyDeviceToJson(this);

  factory MyDevice.fromJson(Map<String, Object?> json) =>
      _$MyDeviceFromJson(json);

  static String databaseTableCreation() {
    return "CREATE TABLE IF NOT EXISTS $_tableName("
        "$_colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$_colDeviceId VARCHAR(3) PRIMARY KEY, "
        "$_colName VARCHAR(19), "
        "$_colIpAddress VARCHAR(15))";
  }

  @override
  Future<MyDevice> insert(DatabaseService dbService) {
    return dbService
        .insert(_tableName, toJson())
        .then((newDbObject) => MyDevice.fromJson(newDbObject));
  }

  @override
  Future<List<MyDevice>> getAll(DatabaseService dbService) {
    return dbService.getAll(_tableName, MyDevice.fromJson);
  }

  @override
  Future<MyDevice> udpate(DatabaseService dbService) {
    return dbService.update(_tableName, toJson()).then((_) => this);
  }

  @override
  Future<void> delete(DatabaseService dbService) {
    return dbService.delete(_tableName, toJson());
  }
}
