import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_app/mixins/mock_repository.dart';
import 'package:home_app/models/node_device_status.dart';
import 'package:home_app/services/requests/http_service.dart';

part 'live_node_device_repository.dart';
part 'mock_node_device_repository.dart';

abstract class NodeDeviceRepository {
  Future<NodeDeviceStatus> getDeviceStatus(String ipAddress);
  Future<void> setDeviceName(String ipAddress, String newName);
  Future<void> setLedColor(String ipAddress, Color color);
  Future<void> setNeonBrightness(String ipAddress, int brightness);
  Future<void> setPowerState(String ipAddress, bool enable);
  Future<void> setMotorSpeed(String ipAddress, int speed);
  Future<void> setMotorPosition(String ipAddress, int position);
  Future<void> setMotorAcceleration(String ipAddress, int acceleration);
}
