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
  bool _hasValueChanged = false;

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
  void onStateChange(context, NameTileDialogState newState) {
    if (newState.hasError) {
      SnackBarPresenter.presentError(
          ScaffoldMessenger.of(context), newState.error!);
    }

    if (newState.hasData && newState.data == true) {
      Navigator.pop<String>(context, _textEditingController.text);
    }
  }

  @override
  Widget buildState(BuildContext context, NameTileDialogState state) {
    return AlertDialog(
      title: const Text("New device name"),
      content: TextField(
        autocorrect: false,
        autofocus: true,
        controller: _textEditingController,
        maxLength: 19,
        onChanged: (_) {
          setState(() {
            _hasValueChanged = true;
          });
        },
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
                onPressed: _hasValueChanged
                    ? () => bloc.add(NewName(_textEditingController.text))
                    : null,
                child: const Text("Save"),
              ),
            ],
    );
  }
}
