part of 'preset_name_tile_dialog_bloc.dart';

abstract class PresetNameTileDialogEvent extends Equatable {
  const PresetNameTileDialogEvent();

  @override
  List<Object> get props => [];
}

class NewName extends PresetNameTileDialogEvent {
  final String newName;

  @override
  List<Object> get props => [newName, ...super.props];

  const NewName(this.newName);
}
