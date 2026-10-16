part of 'preset_name_tile_dialog_bloc.dart';

class PresetNameTileDialogState extends BaseState<bool> {
  const PresetNameTileDialogState.loading({bool? data})
    : super.loading(data: data);
  const PresetNameTileDialogState.data(bool data) : super.data(data: data);
  const PresetNameTileDialogState.error(String error, {bool? data})
    : super.error(error: error, data: data);
}
