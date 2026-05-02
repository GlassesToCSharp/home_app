import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/features/presets/preset/models/preset_action.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
export 'package:home_app/services/database_service/database_service.dart';

part 'action_fab_event.dart';
part 'action_fab_state.dart';

class ActionFabBloc extends Bloc<ActionFabEvent, ActionFabState> {
  final List<PresetAction> presetActions;
  final DatabaseService dbService;
  final NodeDeviceRepository repository;

  ActionFabBloc({
    required this.presetActions,
    required this.dbService,
    required this.repository,
  }) : super(const ActionFabState.data(false)) {
    on<ExecuteActions>(_handleExecuteActionsEvent);
  }

  Future<void> _handleExecuteActionsEvent(
    ExecuteActions event,
    Emitter<ActionFabState> emit,
  ) async {
    emit(const ActionFabState.loading());

    try {
      final futures = presetActions.map((pa) {
        final ipAddress = pa.device!.ipAddress;
        switch (pa.instructionName) {
          case InstructionName.ledColor:
            // (event.red << 16) + (event.green << 8) + event.blue
            final red = (pa.instructionValue >> 16) & 0xFF;
            final green = (pa.instructionValue >> 8) & 0xFF;
            final blue = pa.instructionValue & 0xFF;
            return repository.setLedColor(
              pa.device!.ipAddress,
              red,
              green,
              blue,
              255,
            );

          case InstructionName.neonBrightness:
            return repository.setNeonBrightness(ipAddress, pa.instructionValue);

          case InstructionName.power:
            return repository.setPowerState(
              ipAddress,
              pa.instructionValue == 1 ? true : false,
            );

          case InstructionName.motorAcceleration:
            return repository.setMotorAcceleration(
              ipAddress,
              pa.instructionValue,
            );

          case InstructionName.motorPosition:
            return repository.setMotorPosition(ipAddress, pa.instructionValue);

          case InstructionName.motorSpeed:
            return repository.setMotorSpeed(ipAddress, pa.instructionValue);
        }
      }).toList();

      await Future.wait(
        futures,
        // Complete all futures before anouncing a failure
        eagerError: false,
      );
      emit(const ActionFabState.data(true));
    } catch (e) {
      emit(ActionFabState.error(e.toString(), data: false));
    }
  }
}
