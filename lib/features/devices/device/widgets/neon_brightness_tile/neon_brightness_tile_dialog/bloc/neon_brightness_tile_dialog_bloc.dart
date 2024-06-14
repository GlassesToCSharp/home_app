import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'neon_brightness_tile_dialog_event.dart';
part 'neon_brightness_tile_dialog_state.dart';

class NeonBrightnessTileDialogBloc
    extends Bloc<NeonBrightnessTileDialogEvent, NeonBrightnessTileDialogState> {
  final NodeDeviceRepository repository;
  final String deviceIpAddress;

  NeonBrightnessTileDialogBloc({
    required this.repository,
    required this.deviceIpAddress,
  }) : super(const NeonBrightnessTileDialogState.data(false)) {
    on<NewBrightness>(_handleNewBrightnessEvent);
  }

  Future<void> _handleNewBrightnessEvent(
      NewBrightness event, Emitter<NeonBrightnessTileDialogState> emit) async {
    emit(NeonBrightnessTileDialogState.loading(data: state.data));

    try {
      await repository.setNeonBrightness(
          deviceIpAddress, event.brightness.toInt());
      emit(const NeonBrightnessTileDialogState.data(true));
    } catch (e) {
      emit(NeonBrightnessTileDialogState.error(e.toString(), data: false));
    }
  }
}
