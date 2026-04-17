import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/led_color_tile_dialog/bloc/led_color_tile_dialog_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/models/node_device_led_color.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

export 'package:home_app/models/node_device_led_color.dart';

class LedColorTileDialog extends StatefulWidget {
  final NodeDeviceLedColor color;
  final String ipAddress;

  const LedColorTileDialog({required this.color, required this.ipAddress});

  @override
  State<StatefulWidget> createState() => _LedColorTileDialogState();
}

class _LedColorTileDialogState
    extends
        BlocState<
          LedColorTileDialog,
          LedColorTileDialogBloc,
          LedColorTileDialogEvent,
          LedColorTileDialogState
        > {
  int _red = 0;
  int _green = 0;
  int _blue = 0;
  double _opacity = 1.0;

  bool _haveValuesChanged = false;

  @override
  void initState() {
    super.initState();

    _red = widget.color.red;
    _green = widget.color.green;
    _blue = widget.color.blue;
    _opacity = widget.color.opacity / 255;
  }

  @override
  LedColorTileDialogBloc createBloc(KiwiContainer di) {
    return LedColorTileDialogBloc(
      ipAddress: widget.ipAddress,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  void onStateChange(context, LedColorTileDialogState newState) {
    if (newState.hasError) {
      SnackBarPresenter.presentError(
        ScaffoldMessenger.of(context),
        newState.error!,
      );
    }

    if (newState.hasData && newState.data == true) {
      Navigator.pop<NodeDeviceLedColor>(
        context,
        NodeDeviceLedColor(
          red: _red,
          green: _green,
          blue: _blue,
          opacity: (_opacity * 255).toInt(),
        ),
      );
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
                _red = (value.r * 255.0).round().clamp(0, 255);
                _green = (value.g * 255.0).round().clamp(0, 255);
                _blue = (value.b * 255.0).round().clamp(0, 255);
                _opacity = value.a;
                _haveValuesChanged = true;
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
                onPressed: _haveValuesChanged
                    ? () => bloc.add(
                        NewColor(_red, _green, _blue, (_opacity * 255).toInt()),
                      )
                    : null,
                child: const Text("Save"),
              ),
            ],
    );
  }
}
