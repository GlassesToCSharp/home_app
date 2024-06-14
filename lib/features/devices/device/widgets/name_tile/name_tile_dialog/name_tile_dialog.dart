import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile_dialog/bloc/name_tile_dialog_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

class NameTileDialog extends StatefulWidget {
  final String deviceName;
  final String deviceIpAddress;

  const NameTileDialog(
      {required this.deviceName, required this.deviceIpAddress});

  @override
  State<StatefulWidget> createState() => _NameTileDialogState();
}

class _NameTileDialogState extends BlocState<NameTileDialog, NameTileDialogBloc,
    NameTileDialogEvent, NameTileDialogState> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.deviceName;
  }

  @override
  NameTileDialogBloc createBloc(KiwiContainer di) {
    return NameTileDialogBloc(
      deviceIpAddress: widget.deviceIpAddress,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  Widget buildState(BuildContext context, NameTileDialogState state) {
    if (state.hasError) {
      SnackBarPresenter.presentError(
          ScaffoldMessenger.of(context), state.error!);
    }

    if (state.hasData && state.data == true) {
      Navigator.pop<String>(context, _textEditingController.text);
    }

    return AlertDialog(
      title: const Text("New device name"),
      content: TextField(
        autocorrect: false,
        autofocus: true,
        controller: _textEditingController,
        maxLength: 19,
      ),
      actions: state.loading
          ? [const CircularProgressIndicator()]
          : [
              // Negative action
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),

              // Positive action
              TextButton(
                onPressed: () => bloc.add(NewName(_textEditingController.text)),
                child: const Text("Save"),
              ),
            ],
    );
  }
}
