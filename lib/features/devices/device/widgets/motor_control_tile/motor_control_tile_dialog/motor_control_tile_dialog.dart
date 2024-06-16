import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile_dialog/bloc/motor_control_tile_dialog_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/models/node_device_motor.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

export 'package:home_app/models/node_device_motor.dart';

class MotorControlTileDialog extends StatefulWidget {
  final NodeDeviceMotor motorValues;
  final String deviceIpAddress;

  const MotorControlTileDialog({
    required this.motorValues,
    required this.deviceIpAddress,
  });

  @override
  State<StatefulWidget> createState() => _MotorControlTileDialogState();
}

class _MotorControlTileDialogState extends BlocState<
    MotorControlTileDialog,
    MotorControlTileDialogBloc,
    MotorControlTileDialogEvent,
    MotorControlTileDialogState> {
  int _position = 0;
  int _speed = 0;
  int _acceleration = 0;

  @override
  void initState() {
    super.initState();

    _position = widget.motorValues.position;
    _speed = widget.motorValues.speed;
    _acceleration = widget.motorValues.acceleration;
  }

  @override
  MotorControlTileDialogBloc createBloc(KiwiContainer di) {
    return MotorControlTileDialogBloc(
      ipAddress: widget.deviceIpAddress,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  void onStateChange(context, MotorControlTileDialogState newState) {
    if (newState.hasError) {
      SnackBarPresenter.presentError(
          ScaffoldMessenger.of(context), newState.error!);
    }

    if (newState.hasData && newState.data == true) {
      Navigator.pop<NodeDeviceMotor>(
          context,
          NodeDeviceMotor(
            speed: _speed,
            position: _position,
            acceleration: _acceleration,
          ));
    }
  }

  @override
  Widget buildState(BuildContext context, MotorControlTileDialogState state) {
    return AlertDialog(
      title: const Text("New motor configuration"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Slider(
            maximum: 1000,
            title: "Position",
            value: _position,
            onChange: (newValue) {
              setState(() {
                _position = newValue;
              });
            },
          ),
          _Slider(
            maximum: 1000,
            title: "Speed",
            value: _speed,
            onChange: (newValue) {
              setState(() {
                _speed = newValue;
              });
            },
          ),
          _Slider(
            maximum: 1000,
            title: "Acceleration",
            value: _acceleration,
            onChange: (newValue) {
              setState(() {
                _acceleration = newValue;
              });
            },
          ),
        ],
      ),
      actions: state.loading
          ? [const CircularProgressIndicator()]
          : [
              // Negative action
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),

              // Positive action
              TextButton(
                onPressed: () => bloc.add(NewConfiguration(NodeDeviceMotor(
                  speed: _speed,
                  position: _position,
                  acceleration: _acceleration,
                ))),
                child: const Text("Save"),
              ),
            ],
    );
  }
}

class _Slider extends StatelessWidget {
  final String title;
  final int value;
  final int maximum;
  final Function(int newValue) onChange;

  const _Slider({
    required this.title,
    required this.value,
    required this.maximum,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("New $title: $value"),
        Slider(
          value: value.toDouble(),
          divisions: maximum,
          min: 0,
          max: maximum.toDouble(),
          onChanged: (value) => onChange(value.toInt()),
        ),
      ],
    );
  }
}
