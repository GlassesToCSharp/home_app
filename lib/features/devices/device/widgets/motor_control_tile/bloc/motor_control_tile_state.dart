part of 'motor_control_tile_bloc.dart';

class MotorControlTileState extends BaseState<bool> {
  const MotorControlTileState.loading({bool? data}) : super.loading(data: data);
  const MotorControlTileState.data(bool data) : super.data(data: data);
  const MotorControlTileState.error(String error, {bool? data})
    : super.error(error: error, data: data);
}
