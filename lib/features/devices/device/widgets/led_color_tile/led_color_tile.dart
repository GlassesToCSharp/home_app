import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile_dialog/led_color_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/features/devices/models/device.dart';

export 'package:home_app/features/devices/models/device.dart';

class LedColorTile extends StatefulWidget {
  final Set<Device> devices;

  const LedColorTile({required this.devices});

  @override
  State<LedColorTile> createState() => _LedColorTileState();
}

class _LedColorTileState extends State<LedColorTile> with DeviceHelper {
  bool get _hasLedControl =>
      firstWhere<Device>(widget.devices,
          (device) => device.nodeDeviceStatus?.ledColor != null) !=
      null;
  Device get _firstNonNullDevice => firstWhere<Device>(
      widget.devices, (device) => device.nodeDeviceStatus?.ledColor != null)!;

  NodeDeviceLedColor _color = NodeDeviceLedColor.fromColor(Colors.black);

  @override
  void initState() {
    super.initState();

    if (_hasLedControl) {
      _color = _firstNonNullDevice.nodeDeviceStatus!.ledColor!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("LED Colour"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_color.toHexString()),
          const SizedBox(width: 10),
          Container(
            width: 20,
            height: 20,
            color: _color.toColor(),
          ),
        ],
      ),
      onTap: _hasLedControl
          ? () async {
              final newColor = await showDialog<NodeDeviceLedColor>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return LedColorTileDialog(
                    color: _color,
                    ipAddresses: widget.devices
                        .map((device) => device.ipAddress)
                        .toList(),
                  );
                },
              );
              if (newColor != null) {
                setState(() {
                  _color = newColor;
                });
              }
            }
          : null,
    );
  }
}
