import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/device/device_navigator.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';

class DeviceItem extends StatefulWidget {
  final MyDevice myDevice;

  const DeviceItem(this.myDevice, {super.key});

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  static const _iconSize = 16.0;

  MyDevice get myDevice => widget.myDevice;
  Device get device => myDevice.device!;
  NodeDeviceStatus get deviceNode => device.nodeDeviceStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Positioned.fill(
            child: ListTile(
              // TODO: Only allow onTap if the device exists and it's not loading.
              onTap: () {
                NavigationService.navigateTo(DeviceNavigator(device: device));
              },
              // TODO: initially use MyDevice's name, but then use Device.
              title: Text(myDevice.name),
              titleTextStyle: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              subtitle: Text(device.ipAddress),
              // Show what features are available for each device
              trailing: device.isNodeDevice
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (deviceNode.hasPowerState)
                              const FaIcon(
                                FontAwesomeIcons.boltLightning,
                                color: Colors.amber,
                                size: _iconSize,
                              ),
                            if (deviceNode.hasNeonBrightnessState)
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
                            if (deviceNode.hasLedColorState)
                              const FaIcon(
                                FontAwesomeIcons.palette,
                                color: Colors.red,
                                size: _iconSize,
                              ),
                            if (deviceNode.hasMotorState)
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
          ),
          // isNodeDevice will tell us if the device has been reached.
          if (!device.isNodeDevice)
            // Show a warning message of the list tile
            Positioned.fill(
              child: Container(
                color: Colors.blueGrey.withAlpha(50),
                child: Center(child: Text("Device not available")),
              ),
            ),
        ],
      ),
    );
  }
}
