import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/power_state_tile.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicePage extends StatefulWidget {
  final Set<Device> devices;

  const DevicePage({required this.devices});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  Device get firstDevice => widget.devices.first;

  Device? get powerDevice =>
      _firstWhere((device) => device.nodeDeviceStatus!.power != null);
  Device? get motorDevice =>
      _firstWhere((device) => device.nodeDeviceStatus!.motor != null);
  Device? get ledDevice =>
      _firstWhere((device) => device.nodeDeviceStatus!.ledColor != null);
  Device? get neonDevice =>
      _firstWhere((device) => device.nodeDeviceStatus!.neonBrightness != null);

  Device? _firstWhere(bool Function(Device) test) {
    try {
      return widget.devices.firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      if (widget.devices.length == 1)
        // Device name - only available for one device
        NameTile(device: firstDevice),
      // Power state
      PowerStateTile(device: powerDevice ?? firstDevice),
      // Motor control
      MotorControlTile(device: motorDevice ?? firstDevice),
      // LED colour
      LedColorTile(device: ledDevice ?? firstDevice),
      // Neon Brightness
      NeonBrightnessTile(device: neonDevice ?? firstDevice),
    ];

    return Scaffold(
      appBar: AppBar(
        title: widget.devices.length == 1
            ? Text(firstDevice.ipAddress)
            : Text("${widget.devices.length} devices"),
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Container(
          height: 0.5,
          color: Colors.grey,
        ),
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
