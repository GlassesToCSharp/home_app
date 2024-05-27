import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage();

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final _mockListDevices = <_Device>[
    const _Device("Device 1", "192.168.1.23"),
    const _Device("Device 2", "192.168.1.45"),
    const _Device("Device 3", "192.168.1.67"),
    const _Device("Device 4", "192.168.1.89"),
    const _Device("Device 5", "192.168.1.101"),
    const _Device("Device 1", "192.168.1.23"),
    const _Device("Device 2", "192.168.1.45"),
    const _Device("Device 3", "192.168.1.67"),
    const _Device("Device 4", "192.168.1.89"),
    const _Device("Device 5", "192.168.1.101"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network devices"),
        backgroundColor: Theme.of(context).cardColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.arrowsRotate),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _mockListDevices.length,
              itemBuilder: (_, index) {
                if (index >= _mockListDevices.length) {
                  return const SizedBox();
                }
                final device = _mockListDevices[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          device.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(device.ipAddress),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("WiFi Connection:"),
                    Expanded(child: SizedBox()),
                    Text("ROUTER NAME"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status:"),
                    Expanded(child: SizedBox()),
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    ),
                    Text("Scanning..."),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Device {
  final String name;
  final String ipAddress;

  const _Device(this.name, this.ipAddress);
}
