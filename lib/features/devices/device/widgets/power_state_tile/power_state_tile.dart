import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/power_state_tile/bloc/power_state_tile_bloc.dart';
import 'package:home_app/features/devices/mixins/device_helper.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';

class PowerStateTile extends StatefulWidget {
  final MyDevice myDevice;
  final Preset? preset;
  final Function(bool)? onNewValueSet;

  const PowerStateTile({
    required this.myDevice,
    this.preset,
    this.onNewValueSet,
  });

  @override
  State<PowerStateTile> createState() => _PowerStateTileState();
}

class _PowerStateTileState
    extends
        BlocState<
          PowerStateTile,
          PowerStateTileBloc,
          PowerStateTileEvent,
          PowerStateTileState
        >
    with DeviceHelper {
  Device get _device => widget.myDevice.device!;
  bool get _hasPowerState => _device.nodeDeviceStatus.hasPowerState;

  @override
  PowerStateTileBloc createBloc(KiwiContainer di) {
    return PowerStateTileBloc(
      repository: di.resolve<NodeDeviceRepository>(),
      myDevice: widget.myDevice,
      initialState: _hasPowerState ? _device.nodeDeviceStatus.power! : false,
      dbService: di.resolve<DatabaseService>(),
      preset: widget.preset,
    );
  }

  @override
  void onStateChange(context, PowerStateTileState newState) {
    if (newState.hasError) {
      SnackBarPresenter.presentError(
        ScaffoldMessenger.of(context),
        newState.error!,
      );
    } else if (!newState.loading &&
        newState.hasData &&
        widget.onNewValueSet != null) {
      widget.onNewValueSet!(newState.data!);
    }
  }

  @override
  Widget buildState(BuildContext context, PowerStateTileState state) {
    return SwitchListTile(
      title: const Text("Power"),
      activeThumbColor: Colors.grey[100],
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
