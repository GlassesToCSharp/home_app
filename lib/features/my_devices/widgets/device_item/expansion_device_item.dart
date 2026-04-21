import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile.dart';
import 'package:home_app/features/devices/device/widgets/motor_control_tile/motor_control_tile.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/power_state_tile.dart';
import 'package:home_app/features/my_devices/widgets/device_item/bloc/device_item_bloc.dart';
import 'package:home_app/models/bloc_state.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';

class ExpansionDeviceItem extends StatefulWidget {
  final Device device;
  final bool requestRefreshStatus;
  final Function(MyDevice)? onSave;
  final bool includeNameEdit;

  const ExpansionDeviceItem({
    required this.device,
    this.requestRefreshStatus = false,
    this.onSave,
    this.includeNameEdit = false,
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
  Device get device => widget.device;

  @override
  DeviceItemEvent? get initialEvent => widget.requestRefreshStatus
      ? const GetDeviceData()
      : SetDeviceData(device);

  @override
  DeviceItemBloc createBloc(KiwiContainer di) {
    return DeviceItemBloc(
      device: device,
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
              state.data?.name == null ? device.name : state.data!.name,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(device.ipAddress),
            controlAffinity: ListTileControlAffinity.leading,
            children: state.data == null
                ? <Widget>[]
                : <Widget>[
                    if (widget.includeNameEdit)
                      // Device name
                      NameTile(device: state.data!),
                    if (state.data!.nodeDeviceStatus.hasPowerState)
                      // Power state
                      PowerStateTile(device: state.data!),
                    if (state.data!.nodeDeviceStatus.hasMotorState)
                      // Motor control
                      MotorControlTile(device: state.data!),
                    if (state.data!.nodeDeviceStatus.hasLedColorState)
                      // LED colour
                      LedColorTile(device: state.data!),
                    if (state.data!.nodeDeviceStatus.hasNeonBrightnessState)
                      // Neon Brightness
                      NeonBrightnessTile(device: state.data!),
                  ],
          ),
        ),
        // isNodeDevice will tell us if the device has been reached.
        if (state.loading || !device.isNodeDevice || state.hasError)
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
                      : !device.isNodeDevice
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
