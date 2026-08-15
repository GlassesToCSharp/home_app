part of 'node_device_repository.dart';

class LiveNodeDeviceRepository extends NodeDeviceRepository {
  @override
  Future<NodeDeviceStatus> getDeviceStatus(String ipAddress) {
    return HttpService.get(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["status"]),
    ).then((value) => NodeDeviceStatus.fromJson(value.toMap()));
  }

  @override
  Future<void> setDeviceId(String ipAddress, String newId) {
    return HttpService.post(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["id"]),
      body: {"id": newId},
    );
  }

  @override
  Future<void> setDeviceName(String ipAddress, String newName) {
    return HttpService.post(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["name"]),
      body: {"name": newName},
    );
  }

  @override
  Future<void> setLedColor(String ipAddress, int red, int green, int blue) {
    return HttpService.post(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["led-color"]),
      body: {
        "led-color":
            ((0xFF & 0xFF) << 24) |
            ((red & 0xFF) << 16) |
            ((green & 0xFF) << 8) |
            (blue & 0xFF),
      },
    );
  }

  @override
  Future<void> setNeonBrightness(String ipAddress, int brightness) {
    return HttpService.post(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["neon-brightness"]),
      body: {"neon-brightness": brightness},
    );
  }

  @override
  Future<void> setMotorAcceleration(String ipAddress, int acceleration) {
    return HttpService.post(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["motor", "acceleration"]),
      body: {"acceleration": acceleration},
    );
  }

  @override
  Future<void> setMotorPosition(String ipAddress, int position) {
    return HttpService.post(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["motor", "position"]),
      body: {"position": position},
    );
  }

  @override
  Future<void> setMotorSpeed(String ipAddress, int speed) {
    return HttpService.post(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["motor", "speed"]),
      body: {"speed": speed},
    );
  }

  @override
  Future<void> setPowerState(String ipAddress, bool enable, bool featureState) {
    return HttpService.post(
      hostIpUrl: ipAddress,
      endpoint: _createUrl(["power"]),
      body: _parseWithFeatureState({"state": enable}, featureState),
    );
  }

  Map<String, dynamic> _parseWithFeatureState(
    Map<String, dynamic> data,
    bool featureState,
  ) {
    data["feature_status"] = featureState;
    return data;
  }

  String _createUrl(List<String> path) {
    return path.join("/");
  }
}
