import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/device/device_navigator.dart';
import 'package:home_app/features/my_devices/widgets/device_item/bloc/device_item_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';

class DeviceItem extends StatefulWidget {
  final MyDevice myDevice;
  final Function onDeleteRquest;

  const DeviceItem({
    required this.myDevice,
    required this.onDeleteRquest,
    super.key,
  });

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState
    extends
        BlocState<
          DeviceItem,
          DeviceItemBloc,
          DeviceItemEvent,
          DeviceItemState
        > {
  static const _iconSize = 16.0;

  MyDevice get myDevice => widget.myDevice;

  @override
  DeviceItemEvent? get initialEvent => const GetDeviceData();

  @override
  DeviceItemBloc createBloc(KiwiContainer di) {
    return DeviceItemBloc(
      myDevice: myDevice,
      repository: di.resolve<NodeDeviceRepository>(),
      dbService: di.resolve<DatabaseService>(),
    );
  }

  @override
  Widget buildState(BuildContext context, DeviceItemState state) {
    final device = state.data;
    return Dismissible(
      key: Key(myDevice.deviceId),
      background: Container(
        color: Colors.red[700],
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: FaIcon(FontAwesomeIcons.trash, color: Colors.white),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          widget.onDeleteRquest();
          return Future.value(true);
        }

        return Future.value(false);
      },
      child: Card(
        child: Stack(
          children: [
            ListTile(
              onTap: (state.hasData && !state.loading)
                  ? null
                  : () {
                      NavigationService.navigateTo(
                        DeviceNavigator(device: state.data!),
                      );
                    },
              title: Text(
                myDevice.device?.name == null
                    ? myDevice.name
                    : myDevice.device!.name,
              ),
              titleTextStyle: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              subtitle: Text(myDevice.ipAddress),
              // Show what features are available for each device
              trailing: device == null
                  ? null
                  : device.isNodeDevice
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (device.nodeDeviceStatus.hasPowerState)
                              const FaIcon(
                                FontAwesomeIcons.boltLightning,
                                color: Colors.amber,
                                size: _iconSize,
                              ),
                            if (device.nodeDeviceStatus.hasNeonBrightnessState)
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
                            if (device.nodeDeviceStatus.hasLedColorState)
                              const FaIcon(
                                FontAwesomeIcons.palette,
                                color: Colors.red,
                                size: _iconSize,
                              ),
                            if (device.nodeDeviceStatus.hasMotorState)
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
            ),
            // isNodeDevice will tell us if the device has been reached.
            if (state.loading || device?.isNodeDevice != true || state.hasError)
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
                          : device?.isNodeDevice != true
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
        ),
      ),
    );
  }
}
