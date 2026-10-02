import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/power_state_tile.dart';
import 'package:home_app/features/my_devices/widgets/scaffold_device/bloc/scaffold_device_bloc.dart';
import 'package:home_app/models/bloc_state.dart';

class ScaffoldDevice extends StatefulWidget {
  final MyDevice myDevice;

  const ScaffoldDevice({required this.myDevice, super.key});

  @override
  State<ScaffoldDevice> createState() => _ScaffoldDeviceState();
}

class _ScaffoldDeviceState
    extends
        BlocState<
          ScaffoldDevice,
          ScaffoldDeviceBloc,
          ScaffoldDeviceEvent,
          ScaffoldDeviceState
        > {
  bool _isConfiguring = false;

  @override
  bool get closeBlocOnDispose => false;

  @override
  ScaffoldDeviceBloc createBloc(KiwiContainer di) {
    return context.read<ScaffoldDeviceBloc>();
  }

  @override
  Widget buildState(BuildContext context, ScaffoldDeviceState state) {
    return ListView(
      children: [
        // Device name
        GestureDetector(
          onLongPress: () {
            setState(() {
              _isConfiguring = !_isConfiguring;
            });
          },
          child: NameTile(device: state.data!.device!),
        ),
        Divider(),
        // NameTile(device: state.data!.device!),
        if (state.data!.device!.nodeDeviceStatus.hasPowerState ||
            _isConfiguring)
          // Power state
          PowerStateTile(isConfiguring: _isConfiguring, myDevice: state.data!),
        if (state.data!.device!.nodeDeviceStatus.hasMotorState ||
            _isConfiguring)
          // Motor control
          MotorControlTile(device: state.data!, isConfiguring: _isConfiguring),
        if (state.data!.device!.nodeDeviceStatus.hasLedColorState ||
            _isConfiguring)
          // LED colour
          LedColorTile(myDevice: state.data!, isConfiguring: _isConfiguring),
        if (state.data!.device!.nodeDeviceStatus.hasNeonBrightnessState ||
            _isConfiguring)
          // Neon Brightness
          NeonBrightnessTile(
            myDevice: state.data!,
            isConfiguring: _isConfiguring,
          ),
      ],
    );
  }
}
