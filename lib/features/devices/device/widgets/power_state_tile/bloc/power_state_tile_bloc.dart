import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'power_state_tile_event.dart';
part 'power_state_tile_state.dart';

class PowerStateTileBloc
    extends Bloc<PowerStateTileEvent, PowerStateTileState> {
  final NodeDeviceRepository repository;
  final String ipAddress;

  PowerStateTileBloc({
    required this.repository,
    required this.ipAddress,
    required bool initialState,
  }) : super(PowerStateTileState.data(initialState)) {
    on<NewPowerState>(_handleNewStateEvent);
  }

  Future<void> _handleNewStateEvent(
    NewPowerState event,
    Emitter<PowerStateTileState> emit,
  ) async {
    final initialState = state.data!;

    // Set the new state immediately, as we won't have a loading icon.
    emit(PowerStateTileState.loading(data: event.newState));

    try {
      await repository.setPowerState(ipAddress, event.newState);
      emit(PowerStateTileState.data(event.newState));
    } catch (e) {
      emit(PowerStateTileState.error(e.toString(), data: initialState));
    }
  }
}
