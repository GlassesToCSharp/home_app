import 'package:flutter/material.dart';
import 'package:home_app/features/presets/preset/preset_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

export 'package:home_app/features/devices/models/device.dart';

class PresetNavigator extends BaseNavigator {
  const PresetNavigator();

  @override
  Widget build() {
    return PresetPage();
  }

  @override
  String getRouteName() {
    return "preset";
  }
}
