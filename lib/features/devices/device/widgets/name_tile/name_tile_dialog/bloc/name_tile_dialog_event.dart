part of 'name_tile_dialog_bloc.dart';

abstract class NameTileDialogEvent extends Equatable {
  const NameTileDialogEvent();

  @override
  List<Object> get props => [];
}

class NewName extends NameTileDialogEvent {
  final String newName;

  @override
  List<Object> get props => [newName, ...super.props];

  const NewName(this.newName);
}
