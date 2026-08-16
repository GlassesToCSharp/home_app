import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/feature_tile.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/bloc/led_color_tile_bloc.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile_dialog/led_color_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/models/bloc_state.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';

class LedColorTile extends StatefulWidget {
  final MyDevice myDevice;
  final Preset? preset;
  final Function(int)? onNewValueSet;
  final bool isConfiguring;

  const LedColorTile({
    required this.myDevice,
    this.preset,
    this.onNewValueSet,
    this.isConfiguring = false,
  });

  @override
  State<LedColorTile> createState() => _LedColorTileState();
}

class _LedColorTileState
    extends
        BlocState<
          LedColorTile,
          LedColorTileBloc,
          LedColorTileEvent,
          LedColorTileState
        >
    with DeviceHelper {
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
  LedColorTileBloc createBloc(KiwiContainer di) {
    return LedColorTileBloc(
      initialFeatureState: _hasLedControl,
      device: _device,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  Widget buildState(BuildContext context, LedColorTileState state) {
    return FeatureTile(
      title: "LED Colour",
      isConfiguring: widget.isConfiguring,
      featureState: state.data ?? false,
      onFeatureStateChange: (newFeatureState) =>
          bloc.add(UpdateFeatureState(newFeatureState)),
      isLoading: state.loading,
      child: ListTile(
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
      ),
    );
  }
}
