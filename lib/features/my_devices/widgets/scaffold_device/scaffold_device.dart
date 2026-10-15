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
import 'package:home_app/services/dialogs/quick_dialogs.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class ScaffoldDevice extends StatefulWidget {
  final MyDevice myDevice;
  final VoidCallback onRemoveDevice;

  const ScaffoldDevice({
    required this.myDevice,
    required this.onRemoveDevice,
    super.key,
  });

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
  ScaffoldDeviceEvent? get initialEvent => LoadDevice(widget.myDevice);

  @override
  ScaffoldDeviceBloc createBloc(KiwiContainer di) {
    return context.read<ScaffoldDeviceBloc>();
  }

  @override
  Widget buildState(BuildContext context, ScaffoldDeviceState state) {
    if (state.hasError) {
      return CentralErrorDisplay(
        message: state.error!,
        onRetry: () => bloc.add(LoadDevice(widget.myDevice)),
      );
    } else if (state.loading) {
      return CentralLoadingIndicator();
    } else {
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
            PowerStateTile(
              isConfiguring: _isConfiguring,
              myDevice: state.data!,
            ),
          if (state.data!.device!.nodeDeviceStatus.hasMotorState ||
              _isConfiguring)
            // Motor control
            MotorControlTile(
              device: state.data!,
              isConfiguring: _isConfiguring,
            ),
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

          Center(
            child: TextButton.icon(
              onPressed: () async {
                final remove = await QuickDialogs.confirmationDialogAsync(
                  context,
                  title: "Remove device?",
                  message: "Remove the device from your device list?",
                  positiveButtonText: "Yes",
                  negativeButtonText: "No",
                );
                if (remove == true && state.data != null) {
                  bloc.add(RemoveDevice(state.data!));
                  await bloc.stream.firstWhere((s) => !s.loading);
                  NavigationService.pop();
                  widget.onRemoveDevice();
                }
              },
              label: Text("Remove"),
              icon: FaIcon(FontAwesomeIcons.trash),
            ),
          ),
        ],
      );
    }
  }
}
