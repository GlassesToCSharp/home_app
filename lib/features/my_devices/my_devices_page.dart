import 'dart:async';
import 'dart:math';

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
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';
export 'package:home_app/features/presets/preset/models/preset_action.dart';

class MyDevicesPage extends StatefulWidget {
  final Function(MyDevice, PresetAction)? onDeviceSaved;
  final Preset? preset;

  const MyDevicesPage({this.onDeviceSaved, this.preset});

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
  static const _iconSize = 16.0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _refreshIdentifier = 0;
  int _permissionCounter = 0;

  bool get _isConfiguring => _permissionCounter > 5;

  late Timer _timer;

  @override
  MyDevicesEvent? get initialEvent => const GetMyDevices();

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
  MyDevicesBloc createBloc(KiwiContainer di) {
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
    if (state.hasError) {
      return CentralErrorDisplay(message: state.error!, onRetry: _getMyDevices);
    } else if (state.loading && (!state.hasData || state.data!.isEmpty)) {
      return const CentralLoadingIndicator();
      // } else if (state.data?.isEmpty == true) {
      //   return CentralErrorDisplay(
      //     message: "No saved devices found",
      //     onRetry: _getMyDevices,
      //   );
    } else {
      final deviceCount = state.data!.length;
      if (!state.loading && !state.hasError) {
        _refreshIdentifier = Random().nextInt(10000);
      }

      final devices = state.data!;
      final screenWidth = MediaQuery.of(context).size.width;
      int gridCrossCount = (screenWidth / _maxGridSize).floor();
      if (gridCrossCount == 0) {
        gridCrossCount = 3;
      }

      body = RefreshIndicator.adaptive(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          _getMyDevices();
          await bloc.stream.firstWhere((s) => !s.loading);
        },
        child: GridView.count(
          crossAxisCount: gridCrossCount,
          childAspectRatio: 1.5,
          children: [
            ..._mapDevicesToWidgets(devices),
            CustomListItem(
              onTap: () {
                NavigationService.navigateTo(
                  DevicesNavigator(
                    onDeviceSelected: (device) =>
                        bloc.add(AddToMyDevices(device)),
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

      // body = ListView.builder(
      //   itemCount: deviceCount,
      //   itemBuilder: (_, index) {
      //     if (index >= deviceCount) {
      //       return const SizedBox();
      //     }
      //     final myDevice = state.data![index];
      //     return Dismissible(
      //       key: Key("${state.data![index].deviceId} $_refreshIdentifier"),
      //       background: Container(
      //         color: Colors.red[700],
      //         child: const Align(
      //           alignment: Alignment.centerRight,
      //           child: Padding(
      //             padding: EdgeInsets.only(right: 16),
      //             child: FaIcon(FontAwesomeIcons.trash, color: Colors.white),
      //           ),
      //         ),
      //       ),
      //       direction: DismissDirection.endToStart,
      //       confirmDismiss: (direction) {
      //         if (direction == DismissDirection.endToStart) {
      //           bloc.add(RemoveFromMyDevices(state.data![index]));
      //           return Future.value(true);
      //         }

      //         return Future.value(false);
      //       },
      //       child: ExpansionDeviceItem(
      //         myDevice: myDevice,
      //         preset: widget.preset,
      //         onSave: widget.onDeviceSaved,
      //         isConfiguring: _isConfiguring,
      //         requestRefreshStatus: ![
      //           myDevice.device?.nodeDeviceStatus.hasLedColorState,
      //           myDevice.device?.nodeDeviceStatus.hasMotorState,
      //           myDevice.device?.nodeDeviceStatus.hasNeonBrightnessState,
      //           myDevice.device?.nodeDeviceStatus.hasPowerState,
      //         ].any((i) => i == true),
      //       ),
      //     );
      //   },
      // );

      // if (state.hasData && state.data!.isNotEmpty) {
      //   body = RefreshIndicator(
      //     onRefresh: () {
      //       _getMyDevices();
      //       return bloc.stream.firstWhere((s) => !s.loading);
      //     },
      //     child: body,
      //   );
      // }
    }

    return Scaffold(
      key: _scaffoldKey,
      // Open on the left, as the page navigator is on the right.
      drawer: Drawer(
        child: BlocBuilder<ScaffoldDeviceBloc, ScaffoldDeviceState>(
          bloc: context.read<ScaffoldDeviceBloc>(),
          builder: (_, scaffoldDeviceState) =>
              ScaffoldDevice(myDevice: scaffoldDeviceState.data!),
        ),
      ),
      // appBar: AppBar(
      //   title: GestureDetector(
      //     onTap: () {
      //       debugPrint("Permission counter = $_permissionCounter");
      //       if (_isConfiguring) {
      //         // No need to do anything. Already in the required state.
      //         return;
      //       } else if (_permissionCounter == 5) {
      //         // Run setState to refresh to screen. No bloc needed.
      //         setState(() {});
      //       }

      //       _permissionCounter++;
      //     },
      //     onLongPress: () {
      //       setState(() {
      //         _permissionCounter = 0;
      //       });
      //     },
      //     child: const Text("My devices"),
      //   ),
      //   backgroundColor: _isConfiguring
      //       ? Theme.of(context).hoverColor
      //       : Theme.of(context).primaryColor,
      //   scrolledUnderElevation: 8,
      //   shadowColor: Colors.grey,
      //   actions: [
      //     IconButton(
      //       icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
      //       onPressed: state.loading ? null : _getMyDevices,
      //     ),
      //     IconButton(
      //       icon: const FaIcon(FontAwesomeIcons.plus),
      //       onPressed: state.loading
      //           ? null
      //           : () => NavigationService.navigateTo(
      //               DevicesNavigator(
      //                 onDeviceSelected: (device) =>
      //                     bloc.add(AddToMyDevices(device)),
      //               ),
      //             ),
      //     ),
      //   ],
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: body)],
      ),
    );
  }

  void _getMyDevices() {
    bloc.add(const GetMyDevices());
  }

  void _refreshInterface() {
    // Show refresh indicator programmatically on command.
    _refreshIndicatorKey.currentState?.show();
  }

  List<Widget> _mapDevicesToWidgets(List<MyDevice> devices) {
    return devices.map((device) {
      if (device.device == null) {
        return CustomListItem(onTap: () {}, children: [Text("Unknown device")]);
      }
      return DeviceItem(
        device: device.device!,
        onTap: (_) {
          context.read<ScaffoldDeviceBloc>().add(LoadDevice(device));
          _scaffoldKey.currentState?.openDrawer();
        },
      );
    }).toList();
  }
}
