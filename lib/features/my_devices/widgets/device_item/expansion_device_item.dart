import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/power_state_tile.dart';
import 'package:home_app/features/my_devices/widgets/device_item/bloc/device_item_bloc.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/preset/models/preset_action.dart';
export 'package:home_app/features/presets/models/preset.dart';

class ExpansionDeviceItem extends StatefulWidget {
  final MyDevice myDevice;
  final bool requestRefreshStatus;
  final Function(MyDevice, PresetAction)? onSave;
  final Preset? preset;

  const ExpansionDeviceItem({
    required this.myDevice,
    this.requestRefreshStatus = false,
    this.onSave,
    this.preset,
    super.key,
  });

  @override
  State<ExpansionDeviceItem> createState() => _ExpansionDeviceItemState();
}

class _ExpansionDeviceItemState
    extends
        BlocState<
          ExpansionDeviceItem,
          DeviceItemBloc,
          DeviceItemEvent,
          DeviceItemState
        > {
  MyDevice get myDevice => widget.myDevice;

  @override
  DeviceItemEvent? get initialEvent => widget.requestRefreshStatus
      ? const GetDeviceData()
      : SetDeviceData(widget.myDevice);

  @override
  DeviceItemBloc createBloc(KiwiContainer di) {
    return DeviceItemBloc(
      myDevice: widget.myDevice,
      repository: di.resolve<NodeDeviceRepository>(),
      dbService: di.resolve<DatabaseService>(),
    );
  }

  @override
  Widget buildState(BuildContext context, DeviceItemState state) {
    return Stack(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.blueGrey),
          child: ExpansionTile(
            title: Text(
              state.data?.name == null ? myDevice.name : state.data!.name,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(myDevice.ipAddress),
            controlAffinity: ListTileControlAffinity.leading,
            children: state.data == null
                ? <Widget>[]
                : <Widget>[
                    if (widget.preset == null)
                      // Device name
                      NameTile(device: state.data!.device!),
                    if (state.data!.device!.nodeDeviceStatus.hasPowerState)
                      // Power state
                      PowerStateTile(
                        myDevice: state.data!,
                        preset: widget.preset,
                        onNewValueSet: (newValue) {
                          if (widget.onSave != null) {
                            widget.onSave!(
                              myDevice,
                              PresetAction(
                                id: 0,
                                presetId: widget.preset!.id,
                                deviceId: myDevice.id,
                                instructionName: InstructionName.power,
                                instructionValue: newValue ? 1 : 0,
                              ),
                            );
                          }
                        },
                      ),
                    if (state.data!.device!.nodeDeviceStatus.hasMotorState)
                      // Motor control
                      MotorControlTile(device: state.data!.device!),
                    if (state.data!.device!.nodeDeviceStatus.hasLedColorState)
                      // LED colour
                      LedColorTile(device: state.data!.device!),
                    if (state
                        .data!
                        .device!
                        .nodeDeviceStatus
                        .hasNeonBrightnessState)
                      // Neon Brightness
                      NeonBrightnessTile(
                        myDevice: state.data!,
                        preset: widget.preset,
                        onNewValueSet: (newValue) {
                          NavigationService.pop();
                          if (widget.onSave != null) {
                            widget.onSave!(
                              myDevice,
                              PresetAction(
                                id: 0,
                                presetId: widget.preset!.id,
                                deviceId: myDevice.id,
                                instructionName: InstructionName.neonBrightness,
                                instructionValue: newValue,
                              ),
                            );
                          }
                        },
                      ),
                  ],
          ),
        ),
        // isNodeDevice will tell us if the device has been reached.
        if (state.loading ||
            state.data?.device?.isNodeDevice != true ||
            state.hasError)
          // Show a warning message of the list tile
          Positioned.fill(
            child: Container(
              color: Colors.blueGrey.withAlpha(200),
              child: Center(
                child: Text(
                  state.loading
                      ? "Fetching device data..."
                      : state.hasError
                      ? state.error!
                      : state.data?.device?.isNodeDevice != true
                      ? "Device not available"
                      : "Unknown issue",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
