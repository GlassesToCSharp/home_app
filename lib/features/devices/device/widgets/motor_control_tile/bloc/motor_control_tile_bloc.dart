import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'motor_control_tile_event.dart';
part 'motor_control_tile_state.dart';

class MotorControlTileBloc
    extends Bloc<MotorControlTileEvent, MotorControlTileState> {
  final MyDevice device;
  final NodeDeviceRepository repository;

  MotorControlTileBloc({
    required bool initialFeatureState,
    required this.device,
    required this.repository,
  }) : super(MotorControlTileState.data(initialFeatureState)) {
    on<UpdateFeatureState>(_handleUpdateFeatureStateEvent);
  }

  Future<void> _handleUpdateFeatureStateEvent(
    UpdateFeatureState event,
    Emitter<MotorControlTileState> emit,
  ) async {
    emit(MotorControlTileState.loading(data: state.data));

    try {
      await repository.setMotorAcceleration(device.ipAddress, 0, !state.data!);
      await repository.setMotorPosition(device.ipAddress, 0, !state.data!);
      await repository.setMotorSpeed(device.ipAddress, 0, !state.data!);
      emit(MotorControlTileState.data(!state.data!));
    } catch (e) {
      emit(MotorControlTileState.error(e.toString(), data: state.data));
    }
  }
}
