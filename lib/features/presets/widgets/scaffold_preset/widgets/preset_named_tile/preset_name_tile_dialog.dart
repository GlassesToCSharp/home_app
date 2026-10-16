import 'package:flutter/material.dart';
import 'package:home_app/features/presets/widgets/scaffold_preset/widgets/preset_named_tile/bloc/preset_name_tile_dialog_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/widgets/scaffold_header_tile/scaffold_header_tile_dialog.dart';

class PresetNameTileDialog extends StatefulWidget {
  final Preset preset;

  const PresetNameTileDialog({required this.preset, super.key});

  @override
  State<PresetNameTileDialog> createState() => _PresetNameTileDialogState();
}

class _PresetNameTileDialogState
    extends
        BlocState<
          PresetNameTileDialog,
          PresetNameTileDialogBloc,
          PresetNameTileDialogEvent,
          PresetNameTileDialogState
        > {
  String _title = "";

  @override
  void initState() {
    super.initState();
    _title = widget.preset.name;
  }

  @override
  PresetNameTileDialogBloc createBloc(KiwiContainer di) {
    return PresetNameTileDialogBloc(
      preset: widget.preset,
      dbService: di.resolve<DatabaseService>(),
    );
  }

  @override
  void onStateChange(BuildContext context, PresetNameTileDialogState newState) {
    super.onStateChange(context, newState);

    if (newState.data == true) {
      Navigator.pop<String>(context, _title);
    }
  }

  @override
  Widget buildState(BuildContext context, PresetNameTileDialogState state) {
    return ScaffoldHeaderTileDialog(
      title: widget.preset.name,
      isLoading: state.loading,
      onSave: (newName) {
        bloc.add(NewName(newName));
        _title = newName;
      },
    );
  }
}
