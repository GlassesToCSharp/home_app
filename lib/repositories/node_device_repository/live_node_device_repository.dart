part of 'node_device_repository.dart';

class LiveNodeDeviceRepository extends NodeDeviceRepository {
  @override
  Future<NodeDeviceStatus> getDeviceStatus(String ipAddress) {
    // TODO: implement NodeDeviceStatus
    throw UnimplementedError();
    //return HttpService.get(endpoint: _createUrl(ipAddress, "status")).then((value) => null)
  }

  @override
  Future<void> setDeviceName(String ipAddress, String newName) {
    // TODO: implement setDeviceName
    throw UnimplementedError();
  }

  @override
  Future<void> setLedColor(String ipAddress, Color color) {
    // TODO: implement setLedColor
    throw UnimplementedError();
  }

  @override
  Future<void> setMotorAcceleration(String ipAddress, int acceleration) {
    // TODO: implement setMotorAcceleration
    throw UnimplementedError();
  }

  @override
  Future<void> setMotorPosition(String ipAddress, int position) {
    // TODO: implement setMotorPosition
    throw UnimplementedError();
  }

  @override
  Future<void> setMotorSpeed(String ipAddress, int speed) {
    // TODO: implement setMotorSpeed
    throw UnimplementedError();
  }

  @override
  Future<void> setPowerState(String ipAddress, bool enable) {
    // TODO: implement setPowerState
    throw UnimplementedError();
  }

  String _createUrl(String ipAddress, String endpoint) {
    return [ipAddress, endpoint].join("/");
  }
}
