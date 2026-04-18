import 'package:flutter/material.dart';
import 'package:home_app/features/devices/devices_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

class DevicesNavigator extends BaseNavigator {
  const DevicesNavigator();

  @override
  Widget build() {
    return DevicesPage();
  }

  @override
  String getRouteName() {
    return "devices";
  }
}
