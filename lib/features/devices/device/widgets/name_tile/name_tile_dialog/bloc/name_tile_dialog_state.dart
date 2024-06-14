part of 'name_tile_dialog_bloc.dart';

class NameTileDialogState extends BaseState<bool> {
  const NameTileDialogState.loading({bool? data}) : super.loading(data: data);
  const NameTileDialogState.data(bool data) : super.data(data: data);
  const NameTileDialogState.error(String error, {bool? data})
      : super.error(error: error, data: data);
}
