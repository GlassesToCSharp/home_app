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

part 'neon_brightness_tile_dialog_event.dart';
part 'neon_brightness_tile_dialog_state.dart';

class NeonBrightnessTileDialogBloc
    extends Bloc<NeonBrightnessTileDialogEvent, NeonBrightnessTileDialogState> {
  final NodeDeviceRepository repository;
  final Preset? preset;
  final MyDevice myDevice;
  final DatabaseService dbService;

  NeonBrightnessTileDialogBloc({
    required this.repository,
    required this.myDevice,
    required this.dbService,
    this.preset,
  }) : super(const NeonBrightnessTileDialogState.data(false)) {
    on<NewBrightness>(_handleNewBrightnessEvent);
  }

  Future<void> _handleNewBrightnessEvent(
    NewBrightness event,
    Emitter<NeonBrightnessTileDialogState> emit,
  ) async {
    emit(NeonBrightnessTileDialogState.loading(data: state.data));

    try {
      if (preset == null) {
        await repository.setNeonBrightness(
          myDevice.ipAddress,
          event.brightness,
        );
      } else {
        final presetAction = PresetAction(
          id: 0,
          presetId: preset!.id,
          deviceId: myDevice.id,
          instructionName: InstructionName.neonBrightness,
          instructionValue: event.brightness,
        );
        await presetAction.insert(dbService);
      }
      emit(const NeonBrightnessTileDialogState.data(true));
    } catch (e) {
      emit(NeonBrightnessTileDialogState.error(e.toString(), data: false));
    }
  }
}
