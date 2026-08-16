import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/feature_tile.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/bloc/motor_control_tile_bloc.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile_dialog/motor_control_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/models/bloc_state.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';

class MotorControlTile extends StatefulWidget {
  final MyDevice device;
  final bool isConfiguring;

  const MotorControlTile({required this.device, this.isConfiguring = false});

  @override
  State<MotorControlTile> createState() => _MotorControlTileState();
}

class _MotorControlTileState
    extends
        BlocState<
          MotorControlTile,
          MotorControlTileBloc,
          MotorControlTileEvent,
          MotorControlTileState
        >
    with DeviceHelper {
  NodeDeviceMotor _motor = const NodeDeviceMotor(
    speed: 0,
    position: 0,
    acceleration: 0,
  );

  MyDevice get _device => widget.device;
  bool get _hasMotorControl =>
      _device.device?.nodeDeviceStatus.hasMotorState == true;

  @override
  void initState() {
    super.initState();

    if (_hasMotorControl) {
      _motor = _device.device!.nodeDeviceStatus.motor!;
    }
  }

  @override
  MotorControlTileBloc createBloc(KiwiContainer di) {
    return MotorControlTileBloc(
      initialFeatureState: _hasMotorControl,
      device: _device,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  Widget buildState(BuildContext context, MotorControlTileState state) {
    return FeatureTile(
      title: "Motor",
      isConfiguring: widget.isConfiguring,
      featureState: state.data ?? false,
      onFeatureStateChange: (newFeatureState) =>
          bloc.add(UpdateFeatureState(newFeatureState)),
      isLoading: state.loading,
      child: ListTile(
        title: const Text("Motor"),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children:
              {
                    "Acceleration": _motor.acceleration,
                    "Speed": _motor.speed,
                    "Position": _motor.position,
                  }.entries
                  .toList()
                  .map(
                    (entry) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(entry.key),
                        const SizedBox(width: 5),
                        Text(entry.value.toString()),
                      ],
                    ),
                  )
                  .toList(),
        ),
        onTap: _hasMotorControl
            ? () async {
                final newMotorValues = await showDialog<NodeDeviceMotor>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return MotorControlTileDialog(
                      motorValues: _motor,
                      ipAddress: _device.ipAddress,
                    );
                  },
                );
                if (newMotorValues != null) {
                  setState(() {
                    _motor = newMotorValues;
                  });
                }
              }
            : null,
      ),
    );
  }
}
