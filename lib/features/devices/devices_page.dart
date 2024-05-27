import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/bloc/devices_bloc.dart';
import 'package:home_app/models/bloc_state.dart';

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
    final routerName = state.data!.routerName;
    final devices = state.data!.devices;
    final deviceCount = state.data!.devices.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network devices"),
        backgroundColor: Theme.of(context).cardColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.arrowsRotate),
            onPressed:
                state.loading ? null : () => bloc.add(const ScanForDevices()),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("WiFi Connection:"),
                    const Expanded(child: SizedBox()),
                    Text(routerName),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Status:"),
                    const Expanded(child: SizedBox()),
                    if (state.loading) ...[
                      const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    ],
                    Text(state.loading ? "Scanning..." : "Scan complete"),
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
