import 'package:flutter/material.dart';
import 'package:home_app/features/presets/preset/preset_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

export 'package:home_app/features/presets/models/preset.dart';

class PresetNavigator extends BaseNavigator {
  final Preset preset;

  const PresetNavigator(this.preset);

  @override
  Widget build() {
    return PresetPage(preset);
  }

  @override
  String getRouteName() {
    return "preset";
  }
}
