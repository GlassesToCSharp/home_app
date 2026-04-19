import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/devices_navigator.dart';
import 'package:home_app/features/my_devices/bloc/my_devices_bloc.dart';
import 'package:home_app/features/my_devices/widgets/device_item/device_item.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class MyDevicesPage extends StatefulWidget {
  const MyDevicesPage();

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
  Widget buildState(BuildContext context, MyDevicesState state) {
    Widget body = const SizedBox();
    if (state.hasError) {
      body = CentralErrorDisplay(message: state.error!, onRetry: _getMyDevices);
    } else if (state.loading) {
      body = const CentralLoadingIndicator();
    } else if (!state.hasData) {
      body = CentralErrorDisplay(
        message: "No devices found",
        onRetry: _getMyDevices,
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
          return DeviceItem(devices[index]);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My devices"),
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plus),
            onPressed: state.loading
                ? null
                : () => NavigationService.navigateTo(DevicesNavigator(bloc)),
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
