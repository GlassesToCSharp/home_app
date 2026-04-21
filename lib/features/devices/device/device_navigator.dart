import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/device_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

export 'package:home_app/features/devices/models/device.dart';

class DeviceNavigator extends BaseNavigator {
  final Device device;
  final Function(Device)? onSave;

  const DeviceNavigator({required this.device, this.onSave});

  @override
  Widget build() {
    return DevicePage(device: device, onSave: onSave);
  }

  @override
  String getRouteName() {
    return "device";
  }
}
