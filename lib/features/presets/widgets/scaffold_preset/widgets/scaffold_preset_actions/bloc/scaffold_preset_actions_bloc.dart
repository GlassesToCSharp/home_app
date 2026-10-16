import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/services/database_service/database_service.dart';

part 'scaffold_preset_actions_event.dart';
part 'scaffold_preset_actions_state.dart';

class ScaffoldPresetActionsBloc
    extends Bloc<ScaffoldPresetActionsEvent, ScaffoldPresetActionsState> {
  final DatabaseService dbService;

  ScaffoldPresetActionsBloc({required this.dbService})
    : super(const ScaffoldPresetActionsState.loading()) {
    on<LoadPresetActions>(_handleLoadPresetActionsEvent);
  }

  Future<void> _handleLoadPresetActionsEvent(
    LoadPresetActions event,
    Emitter<ScaffoldPresetActionsState> emit,
  ) async {
    emit(ScaffoldPresetActionsState.loading(data: state.data));

    try {
      final presetActions = await PresetAction.instance().getAll(
        dbService,
        whereColIdName: PresetAction.colPresetId,
        whereColIdValue: event.preset.id,
      );
      emit(ScaffoldPresetActionsState.data(presetActions));
    } catch (e) {
      emit(ScaffoldPresetActionsState.error(e.toString(), data: state.data));
    }
  }
}
