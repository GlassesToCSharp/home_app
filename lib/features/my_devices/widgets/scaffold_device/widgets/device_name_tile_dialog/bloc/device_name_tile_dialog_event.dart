part of 'device_name_tile_dialog_bloc.dart';

abstract class DeviceNameTileDialogEvent extends Equatable {
  const DeviceNameTileDialogEvent();

  @override
  List<Object> get props => [];
}

class NewName extends DeviceNameTileDialogEvent {
  final String newName;

  @override
  List<Object> get props => [newName, ...super.props];

  const NewName(this.newName);
}
