import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/bloc/devices_bloc.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicesPage extends StatefulWidget {
  final Function(Device) onDeviceSelected;

  const DevicesPage({required this.onDeviceSelected});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState
    extends BlocState<DevicesPage, DevicesBloc, DevicesEvent, DevicesState> {
  static const _maxGridSize = 150.0;
  static const _iconSize = 16.0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late Timer _timer;

  @override
  DevicesEvent? get initialEvent => const ScanForDevices();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 120),
      (_) => _refreshInterface(),
    );
  }

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
    } else if (state.loading && !state.hasData) {
      body = const CentralLoadingIndicator();
    } else if (!state.hasData) {
      body = CentralErrorDisplay(
        message: "No devices found",
        onRetry: _scanForDevices,
      );
    } else {
      final devices = state.data!;
      final screenWidth = MediaQuery.of(context).size.width;
      int gridCrossCount = (screenWidth / _maxGridSize).floor();
      if (gridCrossCount == 0) {
        gridCrossCount = 3;
      }

      body = RefreshIndicator.adaptive(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          _scanForDevices();
          await bloc.stream.firstWhere((s) => !s.loading);
        },
        child: GridView.count(
          crossAxisCount: gridCrossCount,
          children: devices.map((device) {
            final icons = <Widget>[];
            if (device.nodeDeviceStatus.hasPowerState) {
              icons.add(
                const FaIcon(
                  FontAwesomeIcons.boltLightning,
                  color: Colors.amber,
                  size: _iconSize,
                ),
              );
            }
            if (device.nodeDeviceStatus.hasNeonBrightnessState) {
              icons.add(
                const FaIcon(
                  FontAwesomeIcons.solidLightbulb,
                  color: Colors.amber,
                  size: _iconSize,
                ),
              );
            }
            if (device.nodeDeviceStatus.hasLedColorState) {
              icons.add(
                const FaIcon(
                  FontAwesomeIcons.palette,
                  color: Colors.red,
                  size: _iconSize,
                ),
              );
            }
            if (device.nodeDeviceStatus.hasMotorState) {
              icons.add(
                const FaIcon(
                  FontAwesomeIcons.gear,
                  color: Colors.blueGrey,
                  size: _iconSize,
                ),
              );
            }
            if (icons.isEmpty) {
              icons.add(const SizedBox(height: _iconSize));
            }
            return SizedBox(
              height: _maxGridSize.toDouble(),
              width: _maxGridSize.toDouble(),
              child: Card(
                child: InkWell(
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
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsetsGeometry.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          device.name,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                        Expanded(
                          child: Center(
                            // TODO: Update icon depending on what's registered.
                            child: FaIcon(FontAwesomeIcons.circleExclamation),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SignalStrengthIndicator.sector(
                              // Match icon button's margin/padding
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              value: device.nodeDeviceStatus.signal,
                              size: 20,
                              // Underestimate the RSSI range for better calibration
                              maxValue: -30,
                              minValue: -80,
                              barCount: 4,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: icons,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: FaIcon(FontAwesomeIcons.heart),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Network devices"),
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _scanForDevices() {
    bloc.add(const ScanForDevices());
  }

  void _refreshInterface() {
    // Show refresh indicator programmatically on command.
    _refreshIndicatorKey.currentState?.show();
  }
}
