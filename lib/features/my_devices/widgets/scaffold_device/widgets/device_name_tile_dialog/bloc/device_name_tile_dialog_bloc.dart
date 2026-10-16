import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/device/widgets/led_color_tile/bloc/led_color_tile_bloc.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/features/devices/models/device.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
export 'package:home_app/services/database_service/database_service.dart';

part 'device_name_tile_dialog_event.dart';
part 'device_name_tile_dialog_state.dart';

class DeviceNameTileDialogBloc
    extends Bloc<DeviceNameTileDialogEvent, DeviceNameTileDialogState> {
  final Device device;
  final DatabaseService dbService;
  final NodeDeviceRepository repository;

  DeviceNameTileDialogBloc({
    required this.device,
    required this.repository,
    required this.dbService,
  }) : super(const DeviceNameTileDialogState.data(false)) {
    on<NewName>(_handleNewNameEvent);
  }

  Future<void> _handleNewNameEvent(
    NewName event,
    Emitter<DeviceNameTileDialogState> emit,
  ) async {
    emit(const DeviceNameTileDialogState.loading());

    try {
      await repository.setDeviceName(device.ipAddress, event.newName);
      emit(const DeviceNameTileDialogState.data(true));
    } catch (e) {
      emit(DeviceNameTileDialogState.error(e.toString(), data: false));
    }
  }
}
