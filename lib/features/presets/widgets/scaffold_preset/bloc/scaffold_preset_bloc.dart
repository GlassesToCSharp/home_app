import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'scaffold_preset_event.dart';
part 'scaffold_preset_state.dart';

class ScaffoldPresetBloc
    extends Bloc<ScaffoldPresetEvent, ScaffoldPresetState> {
  final NodeDeviceRepository repository;
  final DatabaseService dbService;

  ScaffoldPresetBloc({required this.repository, required this.dbService})
    : super(ScaffoldPresetState.idle()) {
    on<LoadPreset>(_onLoadPresetEvent);
    on<RemovePreset>(_onRemovePresetEvent);
  }

  Future<void> _onLoadPresetEvent(
    LoadPreset event,
    Emitter<ScaffoldPresetState> emit,
  ) async {
    emit(ScaffoldPresetState.loading(data: event.preset));

    try {
      final preset = await event.preset.getById(dbService, event.preset.id);
      emit(ScaffoldPresetState.data(preset));
    } catch (e) {
      emit(ScaffoldPresetState.error(e.toString(), data: state.data));
    }
  }

  Future<void> _onRemovePresetEvent(
    RemovePreset event,
    Emitter<ScaffoldPresetState> emit,
  ) async {
    emit(ScaffoldPresetState.loading(data: state.data));

    try {
      await event.preset.delete(dbService);
      emit(ScaffoldPresetState.data(event.preset));
    } catch (e) {
      emit(ScaffoldPresetState.error(e.toString(), data: state.data));
    }
  }
}
