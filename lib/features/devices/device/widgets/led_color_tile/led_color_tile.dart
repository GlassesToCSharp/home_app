import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile_dialog/led_color_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';

class LedColorTile extends StatefulWidget {
  final MyDevice myDevice;
  final Preset? preset;
  final Function(int)? onNewValueSet;

  const LedColorTile({required this.myDevice, this.preset, this.onNewValueSet});

  @override
  State<LedColorTile> createState() => _LedColorTileState();
}

class _LedColorTileState extends State<LedColorTile> with DeviceHelper {
  MyDevice get _device => widget.myDevice;
  bool get _hasLedControl => _device.device!.nodeDeviceStatus.hasLedColorState;

  NodeDeviceLedColor _color = NodeDeviceLedColor.fromColor(Colors.black);

  @override
  void initState() {
    super.initState();

    if (_hasLedControl) {
      _color = _device.device!.nodeDeviceStatus.ledColor!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLedControl) {
      return const SizedBox();
    }

    return ListTile(
      title: const Text("LED Colour"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_color.toHexString()),
          const SizedBox(width: 10),
          Container(width: 20, height: 20, color: _color.toColor()),
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
                    ipAddress: _device.ipAddress,
                    myDevice: _device,
                    preset: widget.preset,
                    onNewValueSet: widget.onNewValueSet,
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
