part of 'node_device_repository.dart';

class MockNodeDeviceRepository extends NodeDeviceRepository {
  static final _deviceList = <String, NodeDeviceStatus>{};

  @override
  Future<NodeDeviceStatus> getDeviceStatus(String ipAddress) {
    final device = NodeDeviceStatus(
      name: "DUMMY ${Random().nextInt(1000)}",
      ledColor: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
      power: Random().nextBool(),
      motor: NodeDeviceMotor(
        acceleration: Random().nextInt(1024),
        position: Random().nextInt(1024),
        speed: Random().nextInt(1024),
      ),
    );

    _deviceList[ipAddress] = device;

    return Future.value(device);
  }

  @override
  Future<void> setDeviceName(String ipAddress, String newName) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(name: newName);
    _deviceList[ipAddress] = device;
    return Future.value(null);
  }

  @override
  Future<void> setLedColor(String ipAddress, Color color) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(ledColor: color);
    _deviceList[ipAddress] = device;
    return Future.value(null);
  }

  @override
  Future<void> setMotorAcceleration(String ipAddress, int acceleration) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(
        motor: _deviceList[ipAddress]!
            .motor!
            .copyWith(acceleration: acceleration));
    _deviceList[ipAddress] = device;
    return Future.value(null);
  }

  @override
  Future<void> setMotorPosition(String ipAddress, int position) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(
        motor: _deviceList[ipAddress]!.motor!.copyWith(position: position));
    _deviceList[ipAddress] = device;
    return Future.value(null);
  }

  @override
  Future<void> setMotorSpeed(String ipAddress, int speed) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!
        .copyWith(motor: _deviceList[ipAddress]!.motor!.copyWith(speed: speed));
    _deviceList[ipAddress] = device;
    return Future.value(null);
  }

  @override
  Future<void> setPowerState(String ipAddress, bool enable) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(power: enable);
    _deviceList[ipAddress] = device;
    return Future.value(null);
  }

  void _checkIpAddressExists(String ipAddress) {
    if (!_deviceList.containsKey(ipAddress)) {
      throw "IP Address not found.";
    }
  }
}
