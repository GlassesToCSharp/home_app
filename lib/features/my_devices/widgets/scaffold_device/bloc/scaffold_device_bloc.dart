import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'scaffold_device_event.dart';
part 'scaffold_device_state.dart';

class ScaffoldDeviceBloc
    extends Bloc<ScaffoldDeviceEvent, ScaffoldDeviceState> {
  final NodeDeviceRepository repository;

  ScaffoldDeviceBloc({required this.repository})
    : super(ScaffoldDeviceState.idle()) {
    on<LoadDevice>(_onLoadDeviceEvent);
  }

  Future<void> _onLoadDeviceEvent(
    LoadDevice event,
    Emitter<ScaffoldDeviceState> emit,
  ) async {
    emit(const ScaffoldDeviceState.loading());

    try {
      // Just load the data?
      emit(ScaffoldDeviceState.data(event.myDevice));
    } catch (e) {
      emit(ScaffoldDeviceState.error(e.toString(), data: state.data));
    }
  }
}
