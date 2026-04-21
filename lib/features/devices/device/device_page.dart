import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/power_state_tile.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicePage extends StatefulWidget {
  final Device device;
  final Function(Device)? onSave;

  const DevicePage({required this.device, this.onSave});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  Device get _device => widget.device;

  @override
  Widget build(BuildContext context) {
    final items = [
      // Device name - only available for one device
      NameTile(device: _device),
      // Power state
      //PowerStateTile(device: _device),
      // Motor control
      MotorControlTile(device: _device),
      // LED colour
      LedColorTile(device: _device),
      // Neon Brightness
      NeonBrightnessTile(device: _device),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_device.ipAddress),
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) =>
            Container(height: 0.5, color: Colors.grey),
        itemCount: items.length + 1, // To include the last separator, add 1.
        itemBuilder: ((context, index) {
          if (index >= items.length) {
            return const SizedBox();
          }
          return items[index];
        }),
      ),
    );
  }
}
