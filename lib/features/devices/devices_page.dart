import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/bloc/devices_bloc.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicesPage extends StatefulWidget {
  final Function(Device) onDeviceSelected;

  const DevicesPage({required this.onDeviceSelected});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState
    extends BlocState<DevicesPage, DevicesBloc, DevicesEvent, DevicesState> {
  static const _iconSize = 16.0;

  @override
  DevicesEvent? get initialEvent => const ScanForDevices();

  @override
  DevicesBloc createBloc(KiwiContainer di) {
    return DevicesBloc(
      repository: di.resolve<NodeDeviceRepository>(),
      connectivityService: di.resolve<ConnectivityService>(),
      dbService: di.resolve<DatabaseService>(),
    );
  }

  @override
  Widget buildState(BuildContext context, DevicesState state) {
    Widget body = const SizedBox();
    if (state.hasError) {
      body = CentralErrorDisplay(
        message: state.error!,
        onRetry: _scanForDevices,
      );
    } else if (state.loading) {
      body = const CentralLoadingIndicator();
    } else if (!state.hasData) {
      body = CentralErrorDisplay(
        message: "No devices found",
        onRetry: _scanForDevices,
      );
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
                if (!device.isNodeDevice) {
                  SnackBarPresenter.presentError(
                    ScaffoldMessenger.of(context),
                    "Cannot add a non-Node device",
                  );
                  return;
                }

                widget.onDeviceSelected(device);
                NavigationService.pop();
              },
              title: Text(device.name),
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
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Network devices"),
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            onPressed: state.loading ? null : _scanForDevices,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: body)],
      ),
    );
  }

  void _scanForDevices() {
    bloc.add(const ScanForDevices());
  }
}
