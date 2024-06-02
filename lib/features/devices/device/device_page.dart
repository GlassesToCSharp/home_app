import 'package:flutter/material.dart';
import 'package:home_app/features/devices/models/device.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  const DevicePage({required this.device});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
