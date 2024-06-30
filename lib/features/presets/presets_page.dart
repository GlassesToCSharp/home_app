import 'package:flutter/material.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/features/presets/models/preset_actions.dart';

class PresetsPage extends StatefulWidget {
  final List<Device> devices;

  const PresetsPage({required this.devices});

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
  int _selectedIndex = -1;

  final _presetActions = <PresetActions>[
    PresetActions(
        name: "Trinity",
        newValues: NodeDeviceStatus(
            name: "",
            power: true,
            neonBrightness: 75,
            ledColor: NodeDeviceLedColor.fromColor(Colors.red),
            motor: const NodeDeviceMotor(
              speed: 200,
              position: 1000,
              acceleration: 200,
            ))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preset Actions"),
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _presetActions.length,
              itemBuilder: (_, index) {
                if (index >= _presetActions.length) {
                  return const SizedBox();
                }
                final presetAction = _presetActions[index];
                return Card(
                  child: ListTile(
                    onTap: widget.devices.isEmpty
                        ? null
                        : () {
                            setState(() {
                              if (_selectedIndex == index) {
                                _selectedIndex = -1;
                              } else {
                                _selectedIndex = index;
                              }
                            });
                          },
                    title: Text(presetAction.name),
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    selected: _selectedIndex == index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex >= 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // TODO: Action the commands
              },
              label: const Text("Action"),
            )
          : null,
    );
  }
}
