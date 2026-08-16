import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'led_color_tile_event.dart';
part 'led_color_tile_state.dart';

class LedColorTileBloc extends Bloc<LedColorTileEvent, LedColorTileState> {
  final MyDevice device;
  final NodeDeviceRepository repository;

  LedColorTileBloc({
    required bool initialFeatureState,
    required this.device,
    required this.repository,
  }) : super(LedColorTileState.data(initialFeatureState)) {
    on<UpdateFeatureState>(_handleUpdateFeatureStateEvent);
  }

  Future<void> _handleUpdateFeatureStateEvent(
    UpdateFeatureState event,
    Emitter<LedColorTileState> emit,
  ) async {
    emit(LedColorTileState.loading(data: state.data));

    try {
      await repository.setLedColor(device.ipAddress, 0, 0, 0, !state.data!);
      emit(LedColorTileState.data(!state.data!));
    } catch (e) {
      emit(LedColorTileState.error(e.toString(), data: state.data));
    }
  }
}
