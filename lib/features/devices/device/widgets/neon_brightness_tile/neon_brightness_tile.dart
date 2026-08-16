import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/feature_tile.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/bloc/neon_brightness_tile_bloc.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/helpers.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile_dialog/neon_brightness_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/models/bloc_state.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';

class NeonBrightnessTile extends StatefulWidget {
  final MyDevice myDevice;
  final Preset? preset;
  final Function(int)? onNewValueSet;
  final bool isConfiguring;

  const NeonBrightnessTile({
    required this.myDevice,
    this.preset,
    this.onNewValueSet,
    this.isConfiguring = false,
  });

  @override
  State<NeonBrightnessTile> createState() => _NeonBrightnessTileState();
}

class _NeonBrightnessTileState
    extends
        BlocState<
          NeonBrightnessTile,
          NeonBrightnessTileBloc,
          NeonBrightnessTileEvent,
          NeonBrightnessTileState
        >
    with DeviceHelper {
  int _brightness = 0;

  MyDevice get _device => widget.myDevice;
  bool get _hasBrightness =>
      _device.device!.nodeDeviceStatus.hasNeonBrightnessState;

  @override
  void initState() {
    super.initState();

    if (_hasBrightness) {
      _brightness = _device.device!.nodeDeviceStatus.neonBrightness!;
    }
  }

  @override
  NeonBrightnessTileBloc createBloc(KiwiContainer di) {
    return NeonBrightnessTileBloc(
      initialFeatureState: _hasBrightness,
      device: widget.myDevice,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  Widget buildState(BuildContext context, NeonBrightnessTileState state) {
    return FeatureTile(
      title: "Neon brightness",
      isConfiguring: widget.isConfiguring,
      featureState: _hasBrightness,
      onFeatureStateChange: (newFeatureState) =>
          bloc.add(UpdateFeatureState(newFeatureState)),
      isLoading: state.loading,
      child: ListTile(
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

                final newBrightness = convertPercentTo8Bit(
                  newBrightnessPercent,
                );
                if (newBrightness != _brightness) {
                  setState(() {
                    _brightness = newBrightness;
                  });
                }
              }
            : null,
      ),
    );
  }
}
