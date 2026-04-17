import 'package:flutter/material.dart';
import 'package:home_app/features/presets/bloc/presets_bloc.dart';
import 'package:home_app/features/presets/models/preset_actions.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

export 'package:home_app/features/devices/models/device.dart';

class PresetsPage extends StatefulWidget {
  final Set<Device> devices;

  const PresetsPage({required this.devices});

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState
    extends BlocState<PresetsPage, PresetsBloc, PresetsEvent, PresetsState> {
  int _selectedIndex = -1;

  final _presetActions = <PresetActions>[
    PresetActions(
      name: "Open Trinity",
      newValues: NodeDeviceStatus(
        id: "",
        name: "",
        power: true,
        neonBrightness: 75,
        ledColor: NodeDeviceLedColor.fromColor(Colors.red),
        motor: const NodeDeviceMotor(
          speed: 200,
          position: 1000,
          acceleration: 200,
        ),
      ),
    ),
    PresetActions(
      name: "Close Trinity",
      newValues: NodeDeviceStatus(
        id: "",
        name: "",
        power: false,
        neonBrightness: 0,
        ledColor: NodeDeviceLedColor.fromColor(Colors.black),
        motor: const NodeDeviceMotor(
          speed: 200,
          position: 0,
          acceleration: 200,
        ),
      ),
    ),
  ];

  @override
  PresetsBloc createBloc(KiwiContainer di) {
    return PresetsBloc(
      devices: widget.devices,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  void onStateChange(context, PresetsState newState) {
    super.onStateChange(context, newState);

    if (newState.hasError) {
      SnackBarPresenter.presentError(
        ScaffoldMessenger.of(context),
        newState.error!,
      );
    } else if (newState.data == true) {
      NavigationService.pop();
    }
  }

  @override
  Widget buildState(BuildContext context, PresetsState state) {
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
                    onTap: widget.devices.isEmpty || state.loading
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
                    titleTextStyle: Theme.of(context).textTheme.bodyLarge!
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
              onPressed: state.loading
                  ? null
                  : () => bloc.add(
                      Execute(_presetActions[_selectedIndex].newValues),
                    ),
              label: state.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Action"),
            )
          : null,
    );
  }
}
