import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/models/device.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  const DevicePage({required this.device});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    final items = [
      // Title - Device name
      Row(
        children: [
          Expanded(
            child: Text(
              widget.device.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Display edit box for device name.
            },
            icon: const Icon(FontAwesomeIcons.pen),
          ),
        ],
      ),
      // Power state
      // Motor control
      // LED colour
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
          return Padding(
            padding: const EdgeInsets.all(20),
            child: items[index],
          );
        }),
      ),
    );
  }
}
