import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/services/database_service/database_service.dart';

part 'preset_event.dart';
part 'preset_state.dart';

class PresetBloc extends Bloc<PresetEvent, PresetState> {
  final Preset preset;
  final DatabaseService dbService;

  PresetBloc({required this.preset, required this.dbService})
    : super(const PresetState.loading()) {
    on<RefreshPresetActions>(_handleRefreshPresetActionsEvent);
    on<AddPresetAction>(_handleAddPresetActionEvent);
    on<RemovePresetAction>(_handleRemovePresetActionEvent);
  }

  Future<void> _handleRefreshPresetActionsEvent(
    RefreshPresetActions event,
    Emitter<PresetState> emit,
  ) async {
    emit(PresetState.loading(data: state.data));
    try {
      final presetActions = await PresetAction.instance().getAll(
        dbService,
        whereClause: "${PresetAction.colPresetId} = ?",
        whereArgs: [preset.id],
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
}
