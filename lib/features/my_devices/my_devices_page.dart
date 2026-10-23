import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/devices_navigator.dart';
import 'package:home_app/features/devices/widgets/device_item/device_item.dart';
import 'package:home_app/features/my_devices/bloc/my_devices_bloc.dart';
import 'package:home_app/features/my_devices/widgets/device_item/expansion_device_item.dart';
import 'package:home_app/features/my_devices/widgets/scaffold_device/bloc/scaffold_device_bloc.dart';
import 'package:home_app/features/my_devices/widgets/scaffold_device/scaffold_device.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';
import 'package:home_app/widgets/custom_list_item.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';
export 'package:home_app/features/presets/preset/models/preset_action.dart';

class MyDevicesPage extends StatefulWidget {
  final Function(MyDevice, PresetAction)? onDeviceSaved;
  final Preset? preset;
  final bool includeAppBar;

  const MyDevicesPage({
    this.onDeviceSaved,
    this.preset,
    this.includeAppBar = false,
  });

  @override
  State<MyDevicesPage> createState() => _MyDevicesPageState();
}

class _MyDevicesPageState
    extends
        BlocState<
          MyDevicesPage,
          MyDevicesBloc,
          MyDevicesEvent,
          MyDevicesState
        > {
  static const _maxGridSize = 150.0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Timer _timer;
  ScaffoldDeviceBloc? _scaffoldDeviceBloc;

  @override
  MyDevicesEvent? get initialEvent => const GetMyDevices();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  @override
  MyDevicesBloc createBloc(KiwiContainer di) {
    _scaffoldDeviceBloc = di.resolve<ScaffoldDeviceBloc>();
    return MyDevicesBloc(
      repository: di.resolve<NodeDeviceRepository>(),
      dbService: di.resolve<DatabaseService>(),
    );
  }

  @override
  void onStateChange(BuildContext context, MyDevicesState newState) {
    super.onStateChange(context, newState);

    if (newState.hasError) {
      SnackBarPresenter.presentError(
        ScaffoldMessenger.of(context),
        newState.error!,
      );
    }
  }

  @override
  Widget buildState(BuildContext context, MyDevicesState state) {
    Widget body = const SizedBox();
    if (state.data?.isEmpty == true && state.hasError) {
      body = CentralErrorDisplay(message: state.error!, onRetry: _getMyDevices);
    } else if (state.loading && (!state.hasData || state.data!.isEmpty)) {
      body = const CentralLoadingIndicator();
    } else {
      final devices = state.data!;
      final screenWidth = MediaQuery.of(context).size.width;
      int gridCrossCount = (screenWidth / _maxGridSize).floor();
      if (gridCrossCount == 0) {
        gridCrossCount = 3;
      }

      body = RefreshIndicator.adaptive(
        key: _refreshIndicatorKey,
        onRefresh: () => bloc.stream.firstWhere((s) => !s.loading),
        child: GridView.count(
          crossAxisCount: gridCrossCount,
          childAspectRatio: 1.5,
          children: [
            ..._mapDevicesToWidgets(devices),
            CustomListItem(
              onTap: () {
                NavigationService.navigateTo(
                  DevicesNavigator(
                    onDeviceSelected: (device) {
                      _refreshIndicatorKey.currentState?.show();
                      bloc.add(AddToMyDevices(device));
                    },
                  ),
                );
              },
              children: [
                Text("Add device"),
                Expanded(
                  child: Center(child: FaIcon(FontAwesomeIcons.circlePlus)),
                ),
                SizedBox(height: 40), // Default 24 size + 8 margin
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.includeAppBar ? AppBar(title: Text("My Devices")) : null,
      onDrawerChanged: (isOpen) {
        // When the drawer opens, stop the timer. When it closes, restart the
        // timer and refresh the page.
        if (isOpen) {
          _timer.cancel();
        } else {
          _startTimer();
          _refreshInterface();
        }
      },
      // Open on the left, as the page navigator is on the right.
      drawer: Drawer(
        child: BlocBuilder<ScaffoldDeviceBloc, ScaffoldDeviceState>(
          bloc: _scaffoldDeviceBloc,
          builder: (_, scaffoldDeviceState) => ScaffoldDevice(
            myDevice: scaffoldDeviceState.data!,
            onRemoveDevice: _refreshInterface,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: body)],
      ),
    );
  }

  void _getMyDevices() {
    bloc.add(const GetMyDevices());
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 120),
      (_) => _refreshInterface(),
    );
  }

  void _refreshInterface() {
    // Show refresh indicator programmatically on command.
    _refreshIndicatorKey.currentState?.show();
    _getMyDevices();
  }

  List<Widget> _mapDevicesToWidgets(List<MyDevice> devices) {
    return devices.map((device) {
      if (device.device == null) {
        return CustomListItem(onTap: () {}, children: [Text("Unknown device")]);
      }
      return DeviceItem(
        device: device.device!,
        onTap: (_) {
          _scaffoldDeviceBloc!.add(LoadDevice(device));
          _scaffoldKey.currentState?.openDrawer();
        },
      );
    }).toList();
  }
}
