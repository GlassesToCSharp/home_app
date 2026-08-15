import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/helpers.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile_dialog/neon_brightness_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';

class NeonBrightnessTile extends StatefulWidget {
  final MyDevice myDevice;
  final Preset? preset;
  final Function(int)? onNewValueSet;

  const NeonBrightnessTile({
    required this.myDevice,
    this.preset,
    this.onNewValueSet,
  });

  @override
  State<NeonBrightnessTile> createState() => _NeonBrightnessTileState();
}

class _NeonBrightnessTileState extends State<NeonBrightnessTile>
    with DeviceHelper {
  MyDevice get _device => widget.myDevice;
  bool get _hasBrightness =>
      _device.device!.nodeDeviceStatus.hasNeonBrightnessState;

  int _brightness = 0;

  @override
  void initState() {
    super.initState();

    if (_hasBrightness) {
      _brightness = _device.device!.nodeDeviceStatus.neonBrightness!;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    myDevice: _device,
                    preset: widget.preset,
                    onNewValueSet: widget.onNewValueSet,
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
