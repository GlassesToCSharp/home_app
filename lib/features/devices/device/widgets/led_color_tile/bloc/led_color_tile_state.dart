part of 'led_color_tile_bloc.dart';

class LedColorTileState extends BaseState<bool> {
  const LedColorTileState.loading({bool? data}) : super.loading(data: data);
  const LedColorTileState.data(bool data) : super.data(data: data);
  const LedColorTileState.error(String error, {bool? data})
    : super.error(error: error, data: data);
}
