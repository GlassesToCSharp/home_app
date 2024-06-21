import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile_dialog/motor_control_tile_dialog.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/features/devices/models/device.dart';

export 'package:home_app/features/devices/models/device.dart';

class MotorControlTile extends StatefulWidget {
  final Set<Device> devices;

  const MotorControlTile({required this.devices});

  @override
  State<MotorControlTile> createState() => _MotorControlTileState();
}

class _MotorControlTileState extends State<MotorControlTile> with DeviceHelper {
  bool get _hasMotorControl =>
      firstWhere<Device>(
          widget.devices, (device) => device.nodeDeviceStatus?.motor != null) !=
      null;
  Device get _firstNonNullDevice => firstWhere<Device>(
      widget.devices, (device) => device.nodeDeviceStatus?.motor != null)!;
  NodeDeviceMotor _motor =
      const NodeDeviceMotor(speed: 0, position: 0, acceleration: 0);

  @override
  void initState() {
    super.initState();

    if (_hasMotorControl) {
      _motor = _firstNonNullDevice.nodeDeviceStatus!.motor!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Motor"),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: {
          "Acceleration": _motor.acceleration,
          "Speed": _motor.speed,
          "Position": _motor.position
        }
            .entries
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
                    ipAddresses: widget.devices
                        .map((device) => device.ipAddress)
                        .toList(),
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
