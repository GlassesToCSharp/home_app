import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/services/database_service/database_service.dart';

part 'presets_event.dart';
part 'presets_state.dart';

class PresetsBloc extends Bloc<PresetsEvent, PresetsState> {
  final DatabaseService dbService;

  PresetsBloc({required this.dbService}) : super(const PresetsState.loading()) {
    // on<Execute>(_handleExecuteEvent);
    on<GetPresets>(_handleGetPresetsEvent);
    on<CreatePreset>(_handleCreatePresetEvent);
    on<UpdatePreset>(_handleUpdatePresetEvent);
    on<RemovePreset>(_handleRemovePresetEvent);
  }

  Future<void> _handleGetPresetsEvent(
    GetPresets event,
    Emitter<PresetsState> emit,
  ) async {
    emit(PresetsState.loading(data: state.data));

    try {
      final presets = await Preset.instance().getAll(dbService);
      emit(PresetsState.data(presets));
    } catch (e) {
      emit(PresetsState.error(e.toString()));
    }
  }

  Future<void> _handleCreatePresetEvent(
    CreatePreset event,
    Emitter<PresetsState> emit,
  ) async {
    try {
      // Check name does not exceed max length in DB.
      if (event.name.length > 29) {
        throw "Name is too long";
      }

      // Setting ID to 0 doesn't matter. It will get updated anyway on DB entry.
      Preset newPreset = Preset(id: 0, name: event.name);
      newPreset = await newPreset.insert(dbService);

      final presets = List<Preset>.from(state.data ?? <Preset>[]);
      presets.add(newPreset);
      emit(PresetsState.data(presets));
    } catch (e) {
      emit(PresetsState.error(e.toString()));
    }
  }

  Future<void> _handleUpdatePresetEvent(
    UpdatePreset event,
    Emitter<PresetsState> emit,
  ) async {
    try {
      final updatedPreset = await event.updatedPreset.udpate(dbService);

      final presets = List<Preset>.from(state.data ?? <Preset>[]);
      final index = presets.indexWhere((p) => p.id == updatedPreset.id);
      if (index == -1) {
        presets.add(updatedPreset);
      } else {
        presets.replaceRange(index, index + 1, [updatedPreset]);
      }
      emit(PresetsState.data(presets));
    } catch (e) {
      emit(PresetsState.error(e.toString()));
    }
  }

  Future<void> _handleRemovePresetEvent(
    RemovePreset event,
    Emitter<PresetsState> emit,
  ) async {
    try {
      await event.preset.delete(dbService);

      final presets = List<Preset>.from(state.data ?? <Preset>[]);
      presets.remove(event.preset);
      emit(PresetsState.data(presets));
    } catch (e) {
      emit(PresetsState.error(e.toString()));
    }
  }
}
