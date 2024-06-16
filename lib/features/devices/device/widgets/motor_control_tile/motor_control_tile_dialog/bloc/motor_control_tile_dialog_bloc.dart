import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/models/node_device_motor.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'motor_control_tile_dialog_event.dart';
part 'motor_control_tile_dialog_state.dart';

class MotorControlTileDialogBloc
    extends Bloc<MotorControlTileDialogEvent, MotorControlTileDialogState> {
  final NodeDeviceRepository repository;
  final String ipAddress;

  MotorControlTileDialogBloc(
      {required this.repository, required this.ipAddress})
      : super(const MotorControlTileDialogState.data(false)) {
    on<NewConfiguration>(_handleNewConfigurationEvent);
  }

  Future<void> _handleNewConfigurationEvent(
      NewConfiguration event, Emitter<MotorControlTileDialogState> emit) async {
    emit(const MotorControlTileDialogState.loading());

    try {
      // Do these sequentially, as the device won't be able to do these simultaneously.
      await repository.setMotorAcceleration(
          ipAddress, event.newConfiguration.acceleration);
      await repository.setMotorSpeed(ipAddress, event.newConfiguration.speed);
      await repository.setMotorPosition(
          ipAddress, event.newConfiguration.position);
      emit(const MotorControlTileDialogState.data(true));
    } catch (e) {
      emit(MotorControlTileDialogState.error(e.toString(), data: false));
    }
  }
}
