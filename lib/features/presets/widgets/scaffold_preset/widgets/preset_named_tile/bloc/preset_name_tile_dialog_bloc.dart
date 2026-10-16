import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/features/presets/models/preset.dart';
export 'package:home_app/services/database_service/database_service.dart';

part 'preset_name_tile_dialog_event.dart';
part 'preset_name_tile_dialog_state.dart';

class PresetNameTileDialogBloc
    extends Bloc<PresetNameTileDialogEvent, PresetNameTileDialogState> {
  final Preset preset;
  final DatabaseService dbService;

  PresetNameTileDialogBloc({required this.preset, required this.dbService})
    : super(const PresetNameTileDialogState.data(false)) {
    on<NewName>(_handleNewNameEvent);
  }

  Future<void> _handleNewNameEvent(
    NewName event,
    Emitter<PresetNameTileDialogState> emit,
  ) async {
    emit(const PresetNameTileDialogState.loading());

    try {
      await Preset(id: preset.id, name: event.newName).udpate(dbService);
      emit(const PresetNameTileDialogState.data(true));
    } catch (e) {
      emit(PresetNameTileDialogState.error(e.toString(), data: false));
    }
  }
}
