import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/device/device_navigator.dart';
import 'package:home_app/features/my_devices/widgets/device_item/bloc/device_item_bloc.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';

class DeviceItem extends StatelessWidget {
  static const maxItemSize = 150.0;
  static const _iconSize = 16.0;

  final Device device;
  final Function(Device) onTap;
  final FaIconData icon;
  final double maxSize;

  const DeviceItem({
    required this.device,
    required this.onTap,
    this.icon = FontAwesomeIcons.circleExclamation,
    this.maxSize = maxItemSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final icons = <Widget>[];
    if (device.nodeDeviceStatus.hasPowerState) {
      icons.add(_formatIcon(FontAwesomeIcons.boltLightning, Colors.amber));
    }
    if (device.nodeDeviceStatus.hasNeonBrightnessState) {
      icons.add(_formatIcon(FontAwesomeIcons.solidLightbulb, Colors.amber));
    }
    if (device.nodeDeviceStatus.hasLedColorState) {
      icons.add(_formatIcon(FontAwesomeIcons.palette, Colors.red));
    }
    if (device.nodeDeviceStatus.hasMotorState) {
      icons.add(_formatIcon(FontAwesomeIcons.gear, Colors.blueGrey));
    }
    if (icons.isEmpty) {
      icons.add(const SizedBox(height: _iconSize));
    }
    return SizedBox(
      height: maxSize,
      width: maxSize,
      child: Card(
        child: InkWell(
          onTap: () {
            onTap(device);
            // NavigationService.pop();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(device.name),
                Expanded(child: Center(child: FaIcon(icon))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    device.nodeDeviceStatus.signal == 0
                        ? FaIcon(
                            FontAwesomeIcons.circleExclamation,
                            color: Colors.amber,
                          )
                        : SignalStrengthIndicator.sector(
                            // Match icon button's margin/padding
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            value: device.nodeDeviceStatus.signal,
                            size: 20,
                            // Underestimate the RSSI range for better calibration
                            maxValue: -30,
                            minValue: -80,
                            barCount: 4,
                          ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: icons,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formatIcon(FaIconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 4),
      child: FaIcon(icon, color: iconColor, size: _iconSize),
    );
  }
}
