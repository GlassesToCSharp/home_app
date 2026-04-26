import 'package:flutter/material.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/features/my_devices/my_devices_page.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';
export 'package:home_app/features/presets/preset/models/preset_action.dart';

class MyDevicesNavigator extends BaseNavigator {
  final Function(MyDevice, PresetAction) onDeviceSaved;
  final Preset? preset;

  const MyDevicesNavigator({required this.onDeviceSaved, this.preset});

  @override
  Widget build() {
    return MyDevicesPage(onDeviceSaved: onDeviceSaved, preset: preset);
  }

  @override
  String getRouteName() {
    return "myDevices";
  }
}
