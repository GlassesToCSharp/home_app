import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile_dialog/led_color_tile_dialog.dart';
import 'package:home_app/features/devices/models/device.dart';

export 'package:home_app/features/devices/models/device.dart';

class LedColorTile extends StatefulWidget {
  final Device device;

  const LedColorTile({required this.device});

  @override
  State<LedColorTile> createState() => _LedColorTileState();
}

class _LedColorTileState extends State<LedColorTile> {
  NodeDeviceLedColor _color = NodeDeviceLedColor.fromColor(Colors.black);

  @override
  void initState() {
    super.initState();

    if (widget.device.nodeDeviceStatus?.ledColor != null) {
      _color = widget.device.nodeDeviceStatus?.ledColor as NodeDeviceLedColor;
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
      onTap: widget.device.nodeDeviceStatus?.ledColor == null
          ? null
          : () async {
              final newColor = await showDialog<NodeDeviceLedColor>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return LedColorTileDialog(
                    color: _color,
                    deviceIpAddress: widget.device.ipAddress,
                  );
                },
              );
              if (newColor != null) {
                setState(() {
                  _color = newColor;
                });
              }
            },
    );
  }
}
