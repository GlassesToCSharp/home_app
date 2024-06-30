import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/bloc/devices_bloc.dart';
import 'package:home_app/features/devices/device/device_navigator.dart';
import 'package:home_app/features/presets/presets_navigator.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage();

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState
    extends BlocState<DevicesPage, DevicesBloc, DevicesEvent, DevicesState> {
  static const _iconSize = 16.0;

  bool _isBulkSelecting = false;
  final _selectedDevices = <Device>{};

  @override
  DevicesEvent? get initialEvent => const ScanForDevices();

  @override
  bool get wantKeepAlive => true;

  @override
  DevicesBloc createBloc(KiwiContainer di) {
    return DevicesBloc(
      repository: di.resolve<NodeDeviceRepository>(),
      connectivityService: di.resolve<ConnectivityService>(),
    );
  }

  @override
  Widget buildState(BuildContext context, DevicesState state) {
    Widget body = const SizedBox();
    if (state.hasError) {
      body =
          CentralErrorDisplay(message: state.error!, onRetry: _scanForDevices);
    } else if (state.loading) {
      body = const CentralLoadingIndicator();
    } else if (!state.hasData) {
      body = CentralErrorDisplay(
          message: "No devices found", onRetry: _scanForDevices);
    } else {
      final devices = state.data!;
      final deviceCount = state.data!.length;
      body = ListView.builder(
        itemCount: deviceCount,
        itemBuilder: (_, index) {
          if (index >= deviceCount) {
            return const SizedBox();
          }
          final device = devices[index];
          final deviceNode = device.nodeDeviceStatus;
          return Card(
            child: ListTile(
              onTap: () {
                if (_isBulkSelecting) {
                  setState(() {
                    if (_selectedDevices.contains(device)) {
                      _selectedDevices.remove(device);
                      if (_selectedDevices.isEmpty) {
                        _isBulkSelecting = false;
                      }
                    } else {
                      _selectedDevices.add(device);
                    }
                  });
                } else {
                  NavigationService.navigateTo(
                      DeviceNavigator(devices: {device}));
                }
              },
              onLongPress: _isBulkSelecting
                  ? null
                  : () {
                      setState(() {
                        _isBulkSelecting = true;
                        _selectedDevices.add(device);
                      });
                    },
              title: Text(device.name),
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
              subtitle: Text(device.ipAddress),
              selected: _selectedDevices.contains(device),
              // Show what features are available for each device
              trailing: device.isNodeDevice
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (deviceNode!.hasPowerState)
                              const Icon(
                                FontAwesomeIcons.boltLightning,
                                color: Colors.amber,
                                size: _iconSize,
                              ),
                            if (deviceNode.hasNeonBrightnessState)
                              const Icon(
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
                              const Icon(
                                FontAwesomeIcons.palette,
                                color: Colors.red,
                                size: _iconSize,
                              ),
                            if (deviceNode.hasMotorState)
                              const Icon(
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
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: _isBulkSelecting
            ? Text("Selected ${_selectedDevices.length} device(s)")
            : const Text("Network devices"),
        backgroundColor: _isBulkSelecting
            ? Theme.of(context).cardColor
            : Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: _isBulkSelecting
            ? [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.xmark),
                  onPressed: () {
                    setState(() {
                      _isBulkSelecting = false;
                      _selectedDevices.clear();
                    });
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.arrowsRotate),
                  onPressed: state.loading ? null : _scanForDevices,
                ),
              ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: body,
          ),
          if (_isBulkSelecting)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                    onPressed: () => NavigationService.navigateTo(
                        DeviceNavigator(devices: _selectedDevices)),
                    child: const Text("Bulk edit")),
                ElevatedButton(
                    onPressed: () => NavigationService.navigateTo(
                        PresetsNavigator(devices: _selectedDevices)),
                    child: const Text("Action preset"))
              ],
            )
        ],
      ),
    );
  }

  void _scanForDevices() {
    bloc.add(const ScanForDevices());
  }
}
