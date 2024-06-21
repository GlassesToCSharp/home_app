import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile_dialog/bloc/led_color_tile_dialog_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/models/node_device_led_color.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

export 'package:home_app/models/node_device_led_color.dart';

class LedColorTileDialog extends StatefulWidget {
  final NodeDeviceLedColor color;
  final List<String> ipAddresses;

  const LedColorTileDialog({
    required this.color,
    required this.ipAddresses,
  });

  @override
  State<StatefulWidget> createState() => _LedColorTileDialogState();
}

class _LedColorTileDialogState extends BlocState<LedColorTileDialog,
    LedColorTileDialogBloc, LedColorTileDialogEvent, LedColorTileDialogState> {
  int _red = 0;
  int _green = 0;
  int _blue = 0;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    _red = widget.color.red;
    _green = widget.color.green;
    _blue = widget.color.blue;
    _opacity = widget.color.opacity / 100;
  }

  @override
  LedColorTileDialogBloc createBloc(KiwiContainer di) {
    return LedColorTileDialogBloc(
      ipAddresses: widget.ipAddresses,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  void onStateChange(context, LedColorTileDialogState newState) {
    if (newState.hasError) {
      SnackBarPresenter.presentError(
          ScaffoldMessenger.of(context), newState.error!);
    }

    if (newState.hasData && newState.data == true) {
      Navigator.pop<NodeDeviceLedColor>(
          context,
          NodeDeviceLedColor(
              red: _red,
              green: _green,
              blue: _blue,
              opacity: (_opacity * 100).toInt()));
    }
  }

  @override
  Widget buildState(BuildContext context, LedColorTileDialogState state) {
    return AlertDialog(
      title: const Text("New colour"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorPicker(
            pickerColor: Color.fromRGBO(_red, _green, _blue, _opacity),
            enableAlpha: true,
            displayThumbColor: true,
            labelTypes: const [],
            onColorChanged: (value) {
              setState(() {
                _red = value.red;
                _green = value.green;
                _blue = value.blue;
                _opacity = value.opacity;
              });
            },
          ),
        ],
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
                onPressed: () => bloc.add(
                    NewColor(_red, _green, _blue, (_opacity * 100).toInt())),
                child: const Text("Save"),
              ),
            ],
    );
  }
}
