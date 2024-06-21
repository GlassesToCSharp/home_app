import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/power_state_tile.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicePage extends StatefulWidget {
  final Set<Device> devices;

  const DevicePage({required this.devices});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> with DeviceHelper {
  Device get firstDevice => widget.devices.first;

  Device? get powerDevice => firstWhere(
      widget.devices, (device) => device.nodeDeviceStatus!.power != null);
  Device? get motorDevice => firstWhere(
      widget.devices, (device) => device.nodeDeviceStatus!.motor != null);
  Device? get ledDevice => firstWhere(
      widget.devices, (device) => device.nodeDeviceStatus!.ledColor != null);
  Device? get neonDevice => firstWhere(widget.devices,
      (device) => device.nodeDeviceStatus!.neonBrightness != null);

  @override
  Widget build(BuildContext context) {
    final items = [
      if (widget.devices.length == 1)
        // Device name - only available for one device
        NameTile(device: firstDevice),
      // Power state
      PowerStateTile(devices: widget.devices),
      // Motor control
      MotorControlTile(devices: widget.devices),
      // LED colour
      LedColorTile(devices: widget.devices),
      // Neon Brightness
      NeonBrightnessTile(devices: widget.devices),
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
