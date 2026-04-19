part of 'node_device_repository.dart';

class MockNodeDeviceRepository extends NodeDeviceRepository
    with MockRepository, DeviceUtils {
  static final _deviceList = <String, NodeDeviceStatus>{};

  @override
  Future<NodeDeviceStatus> getDeviceStatus(String ipAddress) {
    final device = NodeDeviceStatus(
      id: Random().nextBool() ? getRandomString(3) : "",
      name: "DUMMY ${Random().nextInt(1000)}",
      ledColor: Random().nextBool()
          ? NodeDeviceLedColor(
              red: Random().nextInt(256),
              green: Random().nextInt(256),
              blue: Random().nextInt(256),
              opacity: Random().nextInt(256),
            )
          : null,
      power: Random().nextBool() ? Random().nextBool() : null,
      neonBrightness: Random().nextBool() ? Random().nextInt(256) : null,
      motor: Random().nextBool()
          ? NodeDeviceMotor(
              acceleration: Random().nextInt(1000),
              position: Random().nextInt(1000),
              speed: Random().nextInt(1000),
            )
          : null,
    );

    _deviceList[ipAddress] = device;

    return returnDelayed(device);
  }

  @override
  Future<void> setDeviceId(String ipAddress, String newId) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(id: newId);
    _deviceList[ipAddress] = device;

    return returnDelayed(null);
  }

  @override
  Future<void> setDeviceName(String ipAddress, String newName) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(name: newName);
    _deviceList[ipAddress] = device;

    return returnDelayed(null);
  }

  @override
  Future<void> setLedColor(
    String ipAddress,
    int red,
    int green,
    int blue,
    int opacity,
  ) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(
      ledColor: NodeDeviceLedColor(
        red: red,
        green: green,
        blue: blue,
        opacity: opacity,
      ),
    );
    _deviceList[ipAddress] = device;
    return returnDelayed(null);
  }

  @override
  Future<void> setNeonBrightness(String ipAddress, int brightness) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(neonBrightness: brightness);
    _deviceList[ipAddress] = device;
    return returnDelayed(null);
  }

  @override
  Future<void> setMotorAcceleration(String ipAddress, int acceleration) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(
      motor: _deviceList[ipAddress]!.motor!.copyWith(
        acceleration: acceleration,
      ),
    );
    _deviceList[ipAddress] = device;
    return returnDelayed(null);
  }

  @override
  Future<void> setMotorPosition(String ipAddress, int position) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(
      motor: _deviceList[ipAddress]!.motor!.copyWith(position: position),
    );
    _deviceList[ipAddress] = device;
    return returnDelayed(null);
  }

  @override
  Future<void> setMotorSpeed(String ipAddress, int speed) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(
      motor: _deviceList[ipAddress]!.motor!.copyWith(speed: speed),
    );
    _deviceList[ipAddress] = device;
    return returnDelayed(null);
  }

  @override
  Future<void> setPowerState(String ipAddress, bool enable) {
    _checkIpAddressExists(ipAddress);

    final device = _deviceList[ipAddress]!.copyWith(power: enable);
    _deviceList[ipAddress] = device;
    return returnDelayed(null);
  }

  void _checkIpAddressExists(String ipAddress) {
    if (!_deviceList.containsKey(ipAddress)) {
      throw "IP Address not found.";
    }
  }
}
