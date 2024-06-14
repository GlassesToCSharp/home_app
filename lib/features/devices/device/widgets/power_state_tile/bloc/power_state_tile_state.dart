part of 'power_state_tile_bloc.dart';

class PowerStateTileState extends BaseState<bool> {
  const PowerStateTileState.loading({bool? data}) : super.loading(data: data);
  const PowerStateTileState.data(bool data) : super.data(data: data);
  const PowerStateTileState.error(String error, {bool? data})
      : super.error(error: error, data: data);
}
