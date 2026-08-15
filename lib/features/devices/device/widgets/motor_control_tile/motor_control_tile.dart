import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile_dialog/motor_control_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/features/devices/models/device.dart';

export 'package:home_app/features/devices/models/device.dart';

class MotorControlTile extends StatefulWidget {
  final Device device;

  const MotorControlTile({required this.device});

  @override
  State<MotorControlTile> createState() => _MotorControlTileState();
}

class _MotorControlTileState extends State<MotorControlTile> with DeviceHelper {
  Device get _device => widget.device;
  bool get _hasMotorControl => _device.nodeDeviceStatus.hasMotorState;
  NodeDeviceMotor _motor = const NodeDeviceMotor(
    speed: 0,
    position: 0,
    acceleration: 0,
  );

  @override
  void initState() {
    super.initState();

    if (_hasMotorControl) {
      _motor = _device.nodeDeviceStatus.motor!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
