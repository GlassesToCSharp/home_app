part of 'neon_brightness_tile_bloc.dart';

class NeonBrightnessTileState extends BaseState<bool> {
  const NeonBrightnessTileState.loading({bool? data})
    : super.loading(data: data);
  const NeonBrightnessTileState.data(bool data) : super.data(data: data);
  const NeonBrightnessTileState.error(String error, {bool? data})
    : super.error(error: error, data: data);
}
