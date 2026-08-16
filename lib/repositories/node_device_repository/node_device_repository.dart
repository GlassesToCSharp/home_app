import 'dart:math';

import 'package:home_app/mixins/device_utils.dart';
import 'package:home_app/mixins/mock_repository.dart';
import 'package:home_app/models/node_device_status.dart';
import 'package:home_app/services/requests/http_service.dart';

part 'live_node_device_repository.dart';
part 'mock_node_device_repository.dart';

abstract class NodeDeviceRepository {
  Future<NodeDeviceStatus> getDeviceStatus(String ipAddress);
  Future<void> setDeviceId(String ipAddress, String newId);
  Future<void> setDeviceName(String ipAddress, String newName);
  Future<void> setLedColor(
    String ipAddress,
    int red,
    int green,
    int blue, [
    bool? featureState,
  ]);
  Future<void> setNeonBrightness(
    String ipAddress,
    int brightness, [
    bool? featureState,
  ]);
  Future<void> setPowerState(
    String ipAddress,
    bool enable, [
    bool? featureState,
  ]);
  Future<void> setMotorSpeed(String ipAddress, int speed, [bool? featureState]);
  Future<void> setMotorPosition(
    String ipAddress,
    int position, [
    bool? featureState,
  ]);
  Future<void> setMotorAcceleration(
    String ipAddress,
    int acceleration, [
    bool? featureState,
  ]);
}
