import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
export 'package:home_app/services/database_service/database_service.dart';

part 'device_item_event.dart';
part 'device_item_state.dart';

class DeviceItemBloc extends Bloc<DeviceItemEvent, DeviceItemState> {
  final Device device;
  final NodeDeviceRepository repository;
  final DatabaseService dbService;

  DeviceItemBloc({
    required this.device,
    required this.repository,
    required this.dbService,
  }) : super(const DeviceItemState.loading()) {
    on<SetDeviceData>(_handleSetDeviceDataEvent);
    on<GetDeviceData>(_handleGetDeviceDataEvent);
    on<UpdateDeviceData>(_handleUpdateDeviceDataEvent);
  }

  Future<void> _handleSetDeviceDataEvent(
    SetDeviceData event,
    Emitter<DeviceItemState> emit,
  ) async {
    emit(DeviceItemState.data(event.device));
  }

  Future<void> _handleGetDeviceDataEvent(
    GetDeviceData event,
    Emitter<DeviceItemState> emit,
  ) async {
    emit(const DeviceItemState.loading());

    try {
      final deviceStatus = await repository.getDeviceStatus(device.ipAddress);
      if (deviceStatus.id != device.nodeDeviceStatus.id) {
        throw "Device ID does not match";
      }

      emit(
        DeviceItemState.data(
          Device(ipAddress: device.ipAddress, nodeDeviceStatus: deviceStatus),
        ),
      );
    } catch (e) {
      emit(DeviceItemState.error(e.toString()));
    }
  }

  Future<void> _handleUpdateDeviceDataEvent(
    UpdateDeviceData event,
    Emitter<DeviceItemState> emit,
  ) async {
    if (device.nodeDeviceStatus.id != event.device.nodeDeviceStatus.id) {
      // If the device IDs do not match, this is a different device.
      return;
    }

    MyDevice newMyDevice = MyDevice.fromDevice(device);
    if (newMyDevice.name != event.device.name) {
      newMyDevice = newMyDevice.copyWith(name: event.device.name);
    }

    try {
      await newMyDevice.udpate(dbService);
    } catch (_) {
      // Ignore the errors and fail silently.
    }
  }
}
