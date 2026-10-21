import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'scaffold_device_event.dart';
part 'scaffold_device_state.dart';

class ScaffoldDeviceBloc
    extends Bloc<ScaffoldDeviceEvent, ScaffoldDeviceState> {
  final NodeDeviceRepository repository;
  final DatabaseService dbService;

  ScaffoldDeviceBloc({required this.repository, required this.dbService})
    : super(ScaffoldDeviceState.idle()) {
    on<LoadDevice>(_onLoadDeviceEvent);
    on<RemoveDevice>(_onRemoveDeviceEvent);
  }

  Future<void> _onLoadDeviceEvent(
    LoadDevice event,
    Emitter<ScaffoldDeviceState> emit,
  ) async {
    emit(ScaffoldDeviceState.loading(data: event.myDevice));

    try {
      final nodeDevice = await repository.getDeviceStatus(
        event.myDevice.ipAddress,
      );
      final device = event.myDevice.withDevice(
        Device(
          ipAddress: event.myDevice.ipAddress,
          nodeDeviceStatus: nodeDevice,
        ),
      );
      emit(ScaffoldDeviceState.data(device));
    } catch (e) {
      emit(ScaffoldDeviceState.error(e.toString(), data: state.data));
    }
  }

  Future<void> _onRemoveDeviceEvent(
    RemoveDevice event,
    Emitter<ScaffoldDeviceState> emit,
  ) async {
    emit(ScaffoldDeviceState.loading(data: event.myDevice));

    try {
      await event.myDevice.delete(dbService);
      emit(ScaffoldDeviceState.data(event.myDevice));
    } catch (e) {
      emit(ScaffoldDeviceState.error(e.toString(), data: state.data));
    }
  }
}
