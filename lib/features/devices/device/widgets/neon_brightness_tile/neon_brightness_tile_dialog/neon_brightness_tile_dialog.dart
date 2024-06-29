import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/helpers.dart';
import 'package:home_app/features/devices/device/widgets/neon_brightness_tile/neon_brightness_tile_dialog/bloc/neon_brightness_tile_dialog_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

class NeonBrightnessTileDialog extends StatefulWidget {
  final int brightness;
  final List<String> ipAddresses;

  const NeonBrightnessTileDialog({
    required this.brightness,
    required this.ipAddresses,
  });

  @override
  State<StatefulWidget> createState() => _NeonBrightnessTileDialogState();
}

class _NeonBrightnessTileDialogState extends BlocState<
    NeonBrightnessTileDialog,
    NeonBrightnessTileDialogBloc,
    NeonBrightnessTileDialogEvent,
    NeonBrightnessTileDialogState> {
  double _brightness = 0;
  bool _hasValueChanged = false;

  @override
  void initState() {
    super.initState();

    _brightness = widget.brightness.toDouble();
  }

  @override
  NeonBrightnessTileDialogBloc createBloc(KiwiContainer di) {
    return NeonBrightnessTileDialogBloc(
      ipAddresses: widget.ipAddresses,
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  void onStateChange(context, NeonBrightnessTileDialogState newState) {
    if (newState.hasError) {
      SnackBarPresenter.presentError(
          ScaffoldMessenger.of(context), newState.error!);
    }

    if (newState.hasData && newState.data == true) {
      Navigator.pop<double>(context, _brightness);
    }
  }

  @override
  Widget buildState(BuildContext context, NeonBrightnessTileDialogState state) {
    return AlertDialog(
      title: const Text("New neon brightness"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text("New brightness:"),
              const Expanded(child: SizedBox()),
              Text("${_brightness.toInt()}%"),
            ],
          ),
          Slider(
            autofocus: true,
            value: _brightness,
            min: 0,
            divisions: 100,
            max: 100,
            onChanged: (newValue) {
              setState(() {
                _brightness = newValue;
                _hasValueChanged = true;
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
                onPressed: _hasValueChanged
                    ? () => bloc
                        .add(NewBrightness(convertPercentTo8Bit(_brightness)))
                    : null,
                child: const Text("Save"),
              ),
            ],
    );
  }
}
