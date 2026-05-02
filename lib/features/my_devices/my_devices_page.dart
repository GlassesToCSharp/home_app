import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/devices_navigator.dart';
import 'package:home_app/features/my_devices/bloc/my_devices_bloc.dart';
import 'package:home_app/features/my_devices/widgets/device_item/expansion_device_item.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

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
  final _myDevices = <MyDevice>[];

  @override
  MyDevicesEvent? get initialEvent => const GetMyDevices();

  @override
  bool get wantKeepAlive => true;

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
    } else if (!newState.loading && newState.hasData) {
      setState(() {
        _myDevices.clear();
        _myDevices.addAll(newState.data!);
      });
    }
  }

  @override
  Widget buildState(BuildContext context, MyDevicesState state) {
    Widget body = const SizedBox();
    if (state.hasError) {
      body = CentralErrorDisplay(message: state.error!, onRetry: _getMyDevices);
    } else if (state.loading && (!state.hasData || state.data!.isEmpty)) {
      body = const CentralLoadingIndicator();
    } else if (_myDevices.isEmpty) {
      body = CentralErrorDisplay(
        message: "No devices found",
        onRetry: _getMyDevices,
      );
    } else {
      final deviceCount = _myDevices.length;
      body = ListView.builder(
        itemCount: deviceCount,
        itemBuilder: (_, index) {
          if (index >= deviceCount) {
            return const SizedBox();
          }
          final myDevice = _myDevices[index];
          return Dismissible(
            key: Key(_myDevices[index].deviceId),
            background: Container(
              color: Colors.red[700],
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: FaIcon(FontAwesomeIcons.trash, color: Colors.white),
                ),
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              if (direction == DismissDirection.endToStart) {
                bloc.add(RemoveFromMyDevices(_myDevices[index]));
                return Future.value(true);
              }

              return Future.value(false);
            },
            child: ExpansionDeviceItem(
              myDevice: myDevice,
              preset: widget.preset,
              onSave: widget.onDeviceSaved,
              requestRefreshStatus: ![
                myDevice.device?.nodeDeviceStatus.hasLedColorState,
                myDevice.device?.nodeDeviceStatus.hasMotorState,
                myDevice.device?.nodeDeviceStatus.hasNeonBrightnessState,
                myDevice.device?.nodeDeviceStatus.hasPowerState,
              ].any((i) => i == true),
            ),
          );
        },
      );

      if (state.hasData && state.data!.isNotEmpty) {
        body = RefreshIndicator(
          onRefresh: () {
            _getMyDevices();
            return bloc.stream.firstWhere((s) => !s.loading);
          },
          child: body,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My devices"),
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            onPressed: state.loading ? null : _getMyDevices,
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plus),
            onPressed: state.loading
                ? null
                : () => NavigationService.navigateTo(
                    DevicesNavigator(
                      onDeviceSelected: (device) =>
                          bloc.add(AddToMyDevices(device)),
                    ),
                  ),
          ),
        ],
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
}
