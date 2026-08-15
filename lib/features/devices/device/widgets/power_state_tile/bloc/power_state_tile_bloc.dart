import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/features/presets/models/preset.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
export 'package:home_app/services/database_service/database_service.dart';

part 'power_state_tile_event.dart';
part 'power_state_tile_state.dart';

class PowerStateTileBloc
    extends Bloc<PowerStateTileEvent, PowerStateTileState> {
  final NodeDeviceRepository repository;
  final MyDevice myDevice;
  final Preset? preset;
  final DatabaseService dbService;

  PowerStateTileBloc({
    required this.repository,
    required this.myDevice,
    required bool initialState,
    required this.dbService,
    this.preset,
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
      if (preset == null) {
        await repository.setPowerState(
          myDevice.device!.ipAddress,
          event.newState,
          event.featureState,
        );
      } else {
        final presetAction = PresetAction(
          id: 0,
          presetId: preset!.id,
          deviceId: myDevice.id,
          instructionName: InstructionName.power,
          instructionValue: event.newState ? 1 : 0,
        );
        await presetAction.insert(dbService);
      }
      emit(PowerStateTileState.data(event.newState));
    } catch (e) {
      emit(PowerStateTileState.error(e.toString(), data: initialState));
    }
  }
}
