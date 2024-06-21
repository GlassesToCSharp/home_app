import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'led_color_tile_dialog_event.dart';
part 'led_color_tile_dialog_state.dart';

class LedColorTileDialogBloc
    extends Bloc<LedColorTileDialogEvent, LedColorTileDialogState> {
  final NodeDeviceRepository repository;
  final List<String> ipAddresses;

  LedColorTileDialogBloc({
    required this.repository,
    required this.ipAddresses,
  }) : super(const LedColorTileDialogState.data(false)) {
    on<NewColor>(_handleNewColorEvent);
  }

  Future<void> _handleNewColorEvent(
      NewColor event, Emitter<LedColorTileDialogState> emit) async {
    emit(const LedColorTileDialogState.loading());

    try {
      for (var ipAddress in ipAddresses) {
        await repository.setLedColor(
            ipAddress, event.red, event.green, event.blue, event.opacity);
      }
      emit(const LedColorTileDialogState.data(true));
    } catch (e) {
      emit(LedColorTileDialogState.error(e.toString(), data: false));
    }
  }
}
