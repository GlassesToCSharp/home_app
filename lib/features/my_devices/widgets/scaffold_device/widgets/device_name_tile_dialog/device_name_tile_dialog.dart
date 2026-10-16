import 'package:flutter/material.dart';
import 'package:home_app/features/my_devices/widgets/scaffold_device/widgets/device_name_tile_dialog/bloc/device_name_tile_dialog_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/widgets/scaffold_header_tile/scaffold_header_tile_dialog.dart';

export 'package:home_app/features/devices/models/device.dart';

class DeviceNameTileDialog extends StatefulWidget {
  final Device device;

  const DeviceNameTileDialog({required this.device, super.key});

  @override
  State<DeviceNameTileDialog> createState() => _DeviceNameTileDialogState();
}

class _DeviceNameTileDialogState
    extends
        BlocState<
          DeviceNameTileDialog,
          DeviceNameTileDialogBloc,
          DeviceNameTileDialogEvent,
          DeviceNameTileDialogState
        > {
  String _title = "";

  @override
  void initState() {
    super.initState();
    _title = widget.device.name;
  }

  @override
  DeviceNameTileDialogBloc createBloc(KiwiContainer di) {
    return DeviceNameTileDialogBloc(
      device: widget.device,
      dbService: di.resolve<DatabaseService>(),
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  void onStateChange(BuildContext context, DeviceNameTileDialogState newState) {
    super.onStateChange(context, newState);

    if (newState.data == true) {
      Navigator.pop<String>(context, _title);
    }
  }

  @override
  Widget buildState(BuildContext context, DeviceNameTileDialogState state) {
    return ScaffoldHeaderTileDialog(
      title: widget.device.name,
      isLoading: state.loading,
      onSave: (newName) {
        bloc.add(NewName(newName));
        _title = newName;
      },
    );
  }
}
