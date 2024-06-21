import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/device_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

export 'package:home_app/features/devices/models/device.dart';

class DeviceNavigator extends BaseNavigator {
  final Set<Device> devices;

  const DeviceNavigator({required this.devices});

  @override
  Widget build() {
    return DevicePage(devices: devices);
  }

  @override
  String getRouteName() {
    return "device";
  }
}
