import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/bloc/devices_bloc.dart';
import 'package:home_app/features/devices/device/device_navigator.dart';
// import 'package:home_app/features/devices/widgets/router_status_container/router_status_container.dart';
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
                  NavigationService.navigateTo(DeviceNavigator(device: device));
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
              // TODO: Add what features are available for each device
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
          // RouterStatusContainer(
          //   devicesBloc: bloc,
          // ),
        ],
      ),
      floatingActionButton: _isBulkSelecting
          ? FloatingActionButton.extended(
              onPressed: () {
                // TODO: Navigate to the Device page, passing the Set of devices
              },
              label: const Text("Bulk edit"),
            )
          : null,
    );
  }

  void _scanForDevices() {
    bloc.add(const ScanForDevices());
  }
}
