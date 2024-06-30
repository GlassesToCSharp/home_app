import 'package:flutter/material.dart';
import 'package:home_app/features/presets/presets_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

export 'package:home_app/features/devices/models/device.dart';

class PresetsNavigator extends BaseNavigator {
  final Set<Device> devices;

  const PresetsNavigator({required this.devices});

  @override
  Widget build() {
    return PresetsPage(devices: devices);
  }

  @override
  String getRouteName() {
    return "presets";
  }
}
