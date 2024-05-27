import 'package:flutter/material.dart';
import 'package:home_app/models/node_device_status.dart';

// TODO: Add Mock and Live repositories

abstract class NodeDeviceRepository {
  Future<NodeDeviceStatus> getDeviceStatus(String ipAddress);
  Future<void> setDeviceName(String ipAddress, String newName);
  Future<void> setLedColor(String ipAddress, Color color);
  Future<void> setPowerState(String ipAddress, bool enable);
  Future<void> setMotorSpeed(String ipAddress, int speed);
  Future<void> setMotorPosition(String ipAddress, int position);
  Future<void> setMotorAcceleration(String ipAddress, int acceleration);
}
