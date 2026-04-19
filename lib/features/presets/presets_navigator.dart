import 'package:flutter/material.dart';
import 'package:home_app/features/presets/presets_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

class PresetsNavigator extends BaseNavigator {
  const PresetsNavigator();

  @override
  Widget build() {
    return PresetsPage();
  }

  @override
  String getRouteName() {
    return "presets";
  }
}
