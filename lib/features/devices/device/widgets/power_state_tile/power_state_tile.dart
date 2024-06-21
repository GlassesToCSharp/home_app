import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/bloc/power_state_tile_bloc.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

class PowerStateTile extends StatefulWidget {
  final Set<Device> devices;

  const PowerStateTile({required this.devices});

  @override
  State<PowerStateTile> createState() => _PowerStateTileState();
}

class _PowerStateTileState extends BlocState<PowerStateTile, PowerStateTileBloc,
    PowerStateTileEvent, PowerStateTileState> with DeviceHelper {
  bool get _hasPowerState =>
      firstWhere<Device>(
          widget.devices, (device) => device.nodeDeviceStatus?.power != null) !=
      null;
  Device get _firstDevice => widget.devices.first;

  @override
  PowerStateTileBloc createBloc(KiwiContainer di) {
    return PowerStateTileBloc(
      repository: di.resolve<NodeDeviceRepository>(),
      ipAddresses: widget.devices.map((device) => device.ipAddress).toList(),
      initialState:
          _hasPowerState ? _firstDevice.nodeDeviceStatus!.power! : false,
    );
  }

  @override
  void onStateChange(context, PowerStateTileState newState) {
    if (newState.hasError) {
      SnackBarPresenter.presentError(
          ScaffoldMessenger.of(context), newState.error!);
    }
  }

  @override
  Widget buildState(BuildContext context, PowerStateTileState state) {
    return SwitchListTile(
      title: const Text("Power"),
      activeColor: Colors.grey[100],
      activeTrackColor: Theme.of(context).primaryColor,
      inactiveThumbColor: Colors.grey[700],
      inactiveTrackColor: Colors.grey[350],
      value: _hasPowerState ? state.data! : false,
      onChanged: _hasPowerState && !state.loading
          ? (newValue) => bloc.add(NewPowerState(newValue))
          : null,
    );
  }
}
