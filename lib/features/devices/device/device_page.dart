import 'package:flutter/material.dart';
import 'package:home_app/features/devices/models/device.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  const DevicePage({required this.device});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.device.nodeDeviceStatus!.power ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      // Title - Device name
      ListTile(
        title: const Text("Name"),
        trailing: Text(widget.device.name),
        onTap: () {
          // TODO: Display edit box for device name.
        },
      ),
      // Power state
      if (widget.device.nodeDeviceStatus!.power != null) ...[
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                title: const Text("Power"),
                activeColor: Colors.grey[100],
                activeTrackColor: Theme.of(context).primaryColor,
                inactiveThumbColor: Colors.grey[700],
                inactiveTrackColor: Colors.grey[350],
                value: _switchValue,
                onChanged: (newValue) {
                  setState(() {
                    _switchValue = newValue;
                  });
                  // TODO: Update power state of the device
                },
              ),
            )
          ],
        )
      ],
      // Motor control
      if (widget.device.nodeDeviceStatus!.motor != null) ...[
        ListTile(
          onTap: () {
            // TODO: Navigate to the Motor Handling page
          },
          title: const Text("Motor"),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: {
              "Acceleration":
                  widget.device.nodeDeviceStatus!.motor!.acceleration,
              "Speed": widget.device.nodeDeviceStatus!.motor!.speed,
              "Position": widget.device.nodeDeviceStatus!.motor!.position
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
        ),
      ],
      // LED colour
      if (widget.device.nodeDeviceStatus!.ledColor != null) ...[
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text("LED Colour"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.device.nodeDeviceStatus!.ledColor!.toHexString(),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 20,
                      height: 20,
                      color:
                          widget.device.nodeDeviceStatus!.ledColor!.toColor(),
                    ),
                  ],
                ),
                onTap: () {
                  // TODO: Navigate to the Color Handling page/dialog
                },
              ),
            ),
          ],
        )
      ],
      // Neon Brightness
      if (widget.device.nodeDeviceStatus!.neonBrightness != null) ...[
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text("Neon Brightness"),
                trailing: Text(
                  widget.device.nodeDeviceStatus!.neonBrightness!.toString(),
                ),
                onTap: () {
                  // TODO: Navigate to the Brightness Handling dialog
                },
              ),
            ),
          ],
        )
      ]
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.ipAddress),
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Container(
          height: 0.5,
          color: Colors.grey,
        ),
        itemCount: items.length + 1, // To include the last separator, add 1.
        itemBuilder: ((context, index) {
          if (index >= items.length) {
            return const SizedBox();
          }
          return items[index];
        }),
      ),
    );
  }
}
