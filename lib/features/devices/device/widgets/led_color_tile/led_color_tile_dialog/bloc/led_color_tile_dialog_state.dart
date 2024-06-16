part of 'led_color_tile_dialog_bloc.dart';

class LedColorTileDialogState extends BaseState<bool> {
  const LedColorTileDialogState.loading({bool? data})
      : super.loading(data: data);
  const LedColorTileDialogState.data(bool data) : super.data(data: data);
  const LedColorTileDialogState.error(String error, {bool? data})
      : super.error(error: error, data: data);
}
