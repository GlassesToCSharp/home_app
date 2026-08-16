import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'neon_brightness_tile_event.dart';
part 'neon_brightness_tile_state.dart';

class NeonBrightnessTileBloc
    extends Bloc<NeonBrightnessTileEvent, NeonBrightnessTileState> {
  final MyDevice device;
  final NodeDeviceRepository repository;

  NeonBrightnessTileBloc({
    required bool initialFeatureState,
    required this.device,
    required this.repository,
  }) : super(NeonBrightnessTileState.data(initialFeatureState)) {
    on<UpdateFeatureState>(_handleUpdateFeatureStateEvent);
  }

  Future<void> _handleUpdateFeatureStateEvent(
    UpdateFeatureState event,
    Emitter<NeonBrightnessTileState> emit,
  ) async {
    emit(NeonBrightnessTileState.loading(data: state.data));

    try {
      await repository.setNeonBrightness(device.ipAddress, 0, !state.data!);
      emit(NeonBrightnessTileState.data(!state.data!));
    } catch (e) {
      emit(NeonBrightnessTileState.error(e.toString(), data: state.data));
    }
  }
}
