part of 'neon_brightness_tile_dialog_bloc.dart';

class NeonBrightnessTileDialogState extends BaseState<bool> {
  const NeonBrightnessTileDialogState.loading({bool? data})
      : super.loading(data: data);
  const NeonBrightnessTileDialogState.data(bool data) : super.data(data: data);
  const NeonBrightnessTileDialogState.error(String error, {bool? data})
      : super.error(error: error, data: data);
}
