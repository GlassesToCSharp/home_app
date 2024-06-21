import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile_dialog/neon_brightness_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/features/devices/models/device.dart';

class NeonBrightnessTile extends StatefulWidget {
  final Set<Device> devices;

  const NeonBrightnessTile({required this.devices});

  @override
  State<NeonBrightnessTile> createState() => _NeonBrightnessTileState();
}

class _NeonBrightnessTileState extends State<NeonBrightnessTile>
    with DeviceHelper {
  bool get _hasBrightness =>
      firstWhere<Device>(widget.devices,
          (device) => device.nodeDeviceStatus?.neonBrightness != null) !=
      null;
  Device get _firstNonNullDevice => firstWhere<Device>(widget.devices,
      (device) => device.nodeDeviceStatus?.neonBrightness != null)!;

  int _brightness = 0;

  @override
  void initState() {
    super.initState();

    if (_hasBrightness) {
      _brightness = _firstNonNullDevice.nodeDeviceStatus!.neonBrightness!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Neon brightness"),
      trailing: Text("${_convert8BitToPercent(_brightness)}%"),
      onTap: _hasBrightness
          ? () async {
              final newBrightnessPercent = await showDialog<double>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return NeonBrightnessTileDialog(
                    brightness: _convert8BitToPercent(_brightness),
                    ipAddresses: widget.devices
                        .map((device) => device.ipAddress)
                        .toList(),
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
            }
          : null,
    );
  }

  int _convert8BitToPercent(int value) {
    return (value / 255 * 100).toInt();
  }

  int _convertPercentTo8Bit(double percent) {
    return (percent * 255 / 100).toInt();
  }
}
