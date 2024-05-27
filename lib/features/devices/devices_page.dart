import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/bloc/devices_bloc.dart';
import 'package:home_app/features/devices/widgets/router_status_container/router_status_container.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage();

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState
    extends BlocState<DevicesPage, DevicesBloc, DevicesEvent, DevicesState> {
  @override
  DevicesEvent? get initialEvent => const ScanForDevices();

  @override
  DevicesBloc createBloc(KiwiContainer di) {
    return DevicesBloc();
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Network devices"),
        backgroundColor: Theme.of(context).cardColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
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
          RouterStatusContainer(isScanning: state.loading),
        ],
      ),
    );
  }

  void _scanForDevices() {
    bloc.add(const ScanForDevices());
  }
}
