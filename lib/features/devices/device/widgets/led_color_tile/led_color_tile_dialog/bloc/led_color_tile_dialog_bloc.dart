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

part 'led_color_tile_dialog_event.dart';
part 'led_color_tile_dialog_state.dart';

class LedColorTileDialogBloc
    extends Bloc<LedColorTileDialogEvent, LedColorTileDialogState> {
  final NodeDeviceRepository repository;
  final MyDevice myDevice;
  final Preset? preset;
  final DatabaseService dbService;

  LedColorTileDialogBloc({
    required this.repository,
    required this.myDevice,
    required this.dbService,
    this.preset,
  }) : super(const LedColorTileDialogState.data(false)) {
    on<NewColor>(_handleNewColorEvent);
  }

  Future<void> _handleNewColorEvent(
    NewColor event,
    Emitter<LedColorTileDialogState> emit,
  ) async {
    emit(const LedColorTileDialogState.loading());

    try {
      if (preset == null) {
        await repository.setLedColor(
          myDevice.ipAddress,
          event.red,
          event.green,
          event.blue,
        );
      } else {
        final presetAction = PresetAction(
          id: 0,
          presetId: preset!.id,
          deviceId: myDevice.id,
          instructionName: InstructionName.ledColor,
          instructionValue: (event.red << 16) + (event.green << 8) + event.blue,
        );
        await presetAction.insert(dbService);
      }
      emit(const LedColorTileDialogState.data(true));
    } catch (e) {
      emit(LedColorTileDialogState.error(e.toString(), data: false));
    }
  }
}
