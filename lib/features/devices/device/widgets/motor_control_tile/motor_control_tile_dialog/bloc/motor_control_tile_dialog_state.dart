part of 'motor_control_tile_dialog_bloc.dart';

class MotorControlTileDialogState extends BaseState<bool> {
  const MotorControlTileDialogState.loading({bool? data})
      : super.loading(data: data);
  const MotorControlTileDialogState.data(bool data) : super.data(data: data);
  const MotorControlTileDialogState.error(String error, {bool? data})
      : super.error(error: error, data: data);
}
