part of 'node_device_repository.dart';

class LiveNodeDeviceRepository extends NodeDeviceRepository {
  @override
  Future<NodeDeviceStatus> getDeviceStatus(String ipAddress) {
    return HttpService.get(endpoint: _createUrl(ipAddress, ["status"]))
        .then((value) => NodeDeviceStatus.fromJson(value.toMap()));
  }

  @override
  Future<void> setDeviceName(String ipAddress, String newName) {
    return HttpService.post(
      endpoint: _createUrl(ipAddress, ["name"]),
      body: {
        "name": newName,
      },
    );
  }

  @override
  Future<void> setLedColor(
      String ipAddress, int red, int green, int blue, int opacity) {
    // TODO: implement setLedColor
    throw UnimplementedError();
  }

  @override
  Future<void> setNeonBrightness(String ipAddress, int brightness) {
    return HttpService.post(
      endpoint: _createUrl(ipAddress, ["neon-brightness"]),
      body: {
        "neon-brightness": brightness,
      },
    );
  }

  @override
  Future<void> setMotorAcceleration(String ipAddress, int acceleration) {
    return HttpService.post(
      endpoint: _createUrl(ipAddress, ["motor", "acceleration"]),
      body: {
        "acceleration": acceleration,
      },
    );
  }

  @override
  Future<void> setMotorPosition(String ipAddress, int position) {
    return HttpService.post(
      endpoint: _createUrl(ipAddress, ["motor", "position"]),
      body: {
        "position": position,
      },
    );
  }

  @override
  Future<void> setMotorSpeed(String ipAddress, int speed) {
    return HttpService.post(
      endpoint: _createUrl(ipAddress, ["motor", "speed"]),
      body: {
        "speed": speed,
      },
    );
  }

  @override
  Future<void> setPowerState(String ipAddress, bool enable) {
    return HttpService.post(
      endpoint: _createUrl(ipAddress, ["power"]),
      body: {
        "state": enable,
      },
    );
  }

  String _createUrl(String ipAddress, List<String> path) {
    return [ipAddress, ...path].join("/");
  }
}
