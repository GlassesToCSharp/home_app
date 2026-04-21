import 'package:flutter/material.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/features/my_devices/my_devices_page.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/my_devices/my_devices_page.dart'
    show PagePurpose;

class MyDevicesNavigator extends BaseNavigator {
  final Function(MyDevice) onDeviceSaved;
  final PagePurpose purpose;

  const MyDevicesNavigator({
    required this.onDeviceSaved,
    this.purpose = PagePurpose.modifySavedDevices,
  });

  @override
  Widget build() {
    return MyDevicesPage(onDeviceSaved: onDeviceSaved, purpose: purpose);
  }

  @override
  String getRouteName() {
    return "myDevices";
  }
}
