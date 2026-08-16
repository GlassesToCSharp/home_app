import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/power_state_tile.dart';
import 'package:home_app/features/my_devices/widgets/device_item/bloc/device_item_bloc.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/preset/models/preset_action.dart';
export 'package:home_app/features/presets/models/preset.dart';

class ExpansionDeviceItem extends StatefulWidget {
  final MyDevice myDevice;
  final bool requestRefreshStatus;
  final Function(MyDevice, PresetAction)? onSave;
  final Preset? preset;
  final bool isConfiguring;

  const ExpansionDeviceItem({
    required this.myDevice,
    this.requestRefreshStatus = false,
    this.onSave,
    this.preset,
    this.isConfiguring = false,
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
  static const _iconSize = 16.0;

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
            leading: SignalStrengthIndicator.sector(
              value: state.data?.device?.nodeDeviceStatus.signal ?? -100,
              size: 16,
              // Underestimate the RSSI range for better calibration
              maxValue: -30,
              minValue: -80,
              barCount: 4,
            ),
            // Show what features are available for each device
            trailing: state.data?.device?.isNodeDevice == true
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (state
                              .data!
                              .device!
                              .nodeDeviceStatus
                              .hasPowerState)
                            const FaIcon(
                              FontAwesomeIcons.boltLightning,
                              color: Colors.amber,
                              size: _iconSize,
                            ),
                          if (state
                              .data!
                              .device!
                              .nodeDeviceStatus
                              .hasNeonBrightnessState)
                            const FaIcon(
                              FontAwesomeIcons.solidLightbulb,
                              color: Colors.amber,
                              size: _iconSize,
                            ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (state
                              .data!
                              .device!
                              .nodeDeviceStatus
                              .hasLedColorState)
                            const FaIcon(
                              FontAwesomeIcons.palette,
                              color: Colors.red,
                              size: _iconSize,
                            ),
                          if (state
                              .data!
                              .device!
                              .nodeDeviceStatus
                              .hasMotorState)
                            const FaIcon(
                              FontAwesomeIcons.gear,
                              color: Colors.blueGrey,
                              size: _iconSize,
                            ),
                        ],
                      ),
                    ],
                  )
                : null,
            controlAffinity: ListTileControlAffinity.trailing,
            children: state.data == null
                ? <Widget>[]
                : <Widget>[
                    if (widget.preset == null)
                      // Device name
                      NameTile(device: state.data!.device!),
                    if (state.data!.device!.nodeDeviceStatus.hasPowerState ||
                        widget.isConfiguring)
                      // Power state
                      PowerStateTile(
                        isConfiguring: widget.isConfiguring,
                        myDevice: state.data!,
                        preset: widget.preset,
                        onNewValueSet: (newValue) {
                          if (widget.onSave != null) {
                            NavigationService.pop();
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
                    if (state.data!.device!.nodeDeviceStatus.hasMotorState ||
                        widget.isConfiguring)
                      // Motor control
                      MotorControlTile(
                        device: state.data!,
                        isConfiguring: widget.isConfiguring,
                      ),
                    if (state.data!.device!.nodeDeviceStatus.hasLedColorState ||
                        widget.isConfiguring)
                      // LED colour
                      LedColorTile(
                        myDevice: state.data!,
                        isConfiguring: widget.isConfiguring,
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
                                instructionName: InstructionName.ledColor,
                                instructionValue: newValue,
                              ),
                            );
                          }
                        },
                      ),
                    if (state
                            .data!
                            .device!
                            .nodeDeviceStatus
                            .hasNeonBrightnessState ||
                        widget.isConfiguring)
                      // Neon Brightness
                      NeonBrightnessTile(
                        myDevice: state.data!,
                        isConfiguring: widget.isConfiguring,
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
