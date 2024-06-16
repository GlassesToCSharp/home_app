import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile_dialog/neon_brightness_tile_dialog.dart';
import 'package:home_app/features/devices/models/device.dart';

class NeonBrightnessTile extends StatefulWidget {
  final Device device;

  const NeonBrightnessTile({required this.device});

  @override
  State<NeonBrightnessTile> createState() => _NeonBrightnessTileState();
}

class _NeonBrightnessTileState extends State<NeonBrightnessTile> {
  int _brightness = 0;

  @override
  void initState() {
    super.initState();

    _brightness = widget.device.nodeDeviceStatus?.neonBrightness ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Neon brightness"),
      trailing: Text("${_convert8BitToPercent(_brightness)}%"),
      onTap: widget.device.nodeDeviceStatus?.neonBrightness == null
          ? null
          : () async {
              final newBrightnessPercent = await showDialog<double>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return NeonBrightnessTileDialog(
                    brightness: _convert8BitToPercent(_brightness),
                    deviceIpAddress: widget.device.ipAddress,
                  );
                },
              );
              if (newBrightnessPercent == null) {
                return;
              }

              final newBrightness = _convertPercentTo8Bit(newBrightnessPercent);
              if (newBrightness != _brightness) {
                setState(() {
                  _brightness = newBrightness;
                });
              }
            },
    );
  }

  int _convert8BitToPercent(int value) {
    return (value / 255 * 100).toInt();
  }

  int _convertPercentTo8Bit(double percent) {
    return (percent * 255 / 100).toInt();
  }
}
