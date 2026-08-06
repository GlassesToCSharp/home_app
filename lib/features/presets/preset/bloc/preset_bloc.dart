import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
export 'package:home_app/services/database_service/database_service.dart';

part 'preset_event.dart';
part 'preset_state.dart';

class PresetBloc extends Bloc<PresetEvent, PresetState> {
  final Preset preset;
  final DatabaseService dbService;
  final NodeDeviceRepository repository;

  PresetBloc({
    required this.preset,
    required this.dbService,
    required this.repository,
  }) : super(const PresetState.loading()) {
    on<RefreshPresetActions>(_handleRefreshPresetActionsEvent);
    on<AddPresetAction>(_handleAddPresetActionEvent);
    on<RemovePresetAction>(_handleRemovePresetActionEvent);
    on<ExecuteActions>(_handleExecuteActionsEvent);
  }

  Future<void> _handleRefreshPresetActionsEvent(
    RefreshPresetActions event,
    Emitter<PresetState> emit,
  ) async {
    emit(PresetState.loading(data: state.data));
    try {
      final presetActions = await PresetAction.instance().getAll(
        dbService,
        whereColIdName: PresetAction.colPresetId,
        whereColIdValue: preset.id,
      );

      emit(PresetState.data(presetActions));
    } catch (e) {
      emit(PresetState.error(e.toString(), data: state.data));
    }
  }

  Future<void> _handleAddPresetActionEvent(
    AddPresetAction event,
    Emitter<PresetState> emit,
  ) async {
    // No loading state. Just save.

    try {
      final newPresetAction = await event.presetAction.insert(dbService);

      final presetActions = List<PresetAction>.from(
        state.data ?? <PresetAction>[],
      );
      presetActions.add(newPresetAction);
      emit(PresetState.data(presetActions));
    } catch (e) {
      emit(PresetState.error(e.toString(), data: state.data));
    }
  }

  Future<void> _handleRemovePresetActionEvent(
    RemovePresetAction event,
    Emitter<PresetState> emit,
  ) async {
    // No loading state. Just save.

    try {
      await event.presetAction.delete(dbService);

      final presetActions = List<PresetAction>.from(
        state.data ?? <PresetAction>[],
      );
      final index = presetActions.indexWhere(
        (pa) => pa.id == event.presetAction.id,
      );
      if (index >= 0) {
        presetActions.removeAt(index);
      }
      emit(PresetState.data(presetActions));
    } catch (e) {
      emit(PresetState.error(e.toString(), data: state.data));
    }
  }

  Future<void> _handleExecuteActionsEvent(
    ExecuteActions event,
    Emitter<PresetState> emit,
  ) async {
    final errors = <String>[];

    final presetActions = List<PresetAction>.from(
      state.data ?? <PresetAction>[],
    );

    // Each PresetAction needs to reset its state to "idle".
    for (int i = 0; i < presetActions.length; i++) {
      presetActions.replaceRange(i, i, [
        presetActions[i].copyWith(
          presetActionState: PresetActionState.executing,
        ),
      ]);
    }
    emit(PresetState.loading(data: presetActions));

    // Now reset, we can update each PresetAction sequentially.
    for (int i = 0; i < presetActions.length; i++) {
      // Each PresetAction needs to update its state before and after execution.
      PresetAction pa = presetActions[i].copyWith(
        presetActionState: PresetActionState.executing,
      );
      presetActions.replaceRange(i, i, [pa]);
      emit(PresetState.loading(data: presetActions));
      final ipAddress = pa.device!.ipAddress;
      try {
        switch (pa.instructionName) {
          case InstructionName.ledColor:
            final red = (pa.instructionValue >> 16) & 0xFF;
            final green = (pa.instructionValue >> 8) & 0xFF;
            final blue = pa.instructionValue & 0xFF;
            await repository.setLedColor(
              pa.device!.ipAddress,
              red,
              green,
              blue,
            );
            break;

          case InstructionName.neonBrightness:
            await repository.setNeonBrightness(ipAddress, pa.instructionValue);
            break;

          case InstructionName.power:
            await repository.setPowerState(
              ipAddress,
              pa.instructionValue == 1 ? true : false,
            );
            break;

          case InstructionName.motorAcceleration:
            await repository.setMotorAcceleration(
              ipAddress,
              pa.instructionValue,
            );
            break;

          case InstructionName.motorPosition:
            await repository.setMotorPosition(ipAddress, pa.instructionValue);
            break;

          case InstructionName.motorSpeed:
            await repository.setMotorSpeed(ipAddress, pa.instructionValue);
            break;
        }
        pa = pa.copyWith(presetActionState: PresetActionState.success);
      } catch (e) {
        pa = pa.copyWith(presetActionState: PresetActionState.failed);
        errors.add(e.toString());
      }
      presetActions.replaceRange(i, i, [pa]);
    }
    if (errors.isEmpty) {
      emit(PresetState.data(presetActions));
    } else {
      emit(PresetState.error(errors.first, data: presetActions));
    }
  }
}
