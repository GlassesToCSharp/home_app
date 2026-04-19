import 'package:flutter/material.dart';
import 'package:home_app/features/devices/devices_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

export 'package:home_app/features/my_devices/bloc/my_devices_bloc.dart';

class DevicesNavigator extends BaseNavigator {
  final Function(Device) onDeviceSelected;

  const DevicesNavigator({required this.onDeviceSelected});

  @override
  Widget build() {
    return DevicesPage(onDeviceSelected: onDeviceSelected);
  }

  @override
  String getRouteName() {
    return "devices";
  }
}
