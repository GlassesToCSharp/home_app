import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/helpers.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile_dialog/neon_brightness_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/features/devices/models/device.dart';

class NeonBrightnessTile extends StatefulWidget {
  final Device device;

  const NeonBrightnessTile({required this.device});

  @override
  State<NeonBrightnessTile> createState() => _NeonBrightnessTileState();
}

class _NeonBrightnessTileState extends State<NeonBrightnessTile>
    with DeviceHelper {
  Device get _device => widget.device;
  bool get _hasBrightness => _device.nodeDeviceStatus.hasNeonBrightnessState;

  int _brightness = 0;

  @override
  void initState() {
    super.initState();

    if (_hasBrightness) {
      _brightness = _device.nodeDeviceStatus.neonBrightness!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasBrightness) {
      return const SizedBox();
    }

    return ListTile(
      title: const Text("Neon brightness"),
      trailing: Text("${convert8BitToPercent(_brightness)}%"),
      onTap: _hasBrightness
          ? () async {
              final newBrightnessPercent = await showDialog<double>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return NeonBrightnessTileDialog(
                    brightness: convert8BitToPercent(_brightness),
                    ipAddress: _device.ipAddress,
                  );
                },
              );
              if (newBrightnessPercent == null) {
                return;
              }

              final newBrightness = convertPercentTo8Bit(newBrightnessPercent);
              if (newBrightness != _brightness) {
                setState(() {
                  _brightness = newBrightness;
                });
              }
            }
          : null,
    );
  }
}
