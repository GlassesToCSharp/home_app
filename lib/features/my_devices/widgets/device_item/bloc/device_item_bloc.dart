import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';
import 'package:http/http.dart';

export 'package:home_app/features/my_devices/models/my_device.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
export 'package:home_app/services/database_service/database_service.dart';

part 'device_item_event.dart';
part 'device_item_state.dart';

class DeviceItemBloc extends Bloc<DeviceItemEvent, DeviceItemState> {
  final MyDevice myDevice;
  final NodeDeviceRepository repository;
  final DatabaseService dbService;

  DeviceItemBloc({
    required this.myDevice,
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
    emit(DeviceItemState.data(event.myDevice));
  }

  Future<void> _handleGetDeviceDataEvent(
    GetDeviceData event,
    Emitter<DeviceItemState> emit,
  ) async {
    emit(const DeviceItemState.loading());

    try {
      final myDeviceStatus = await repository.getDeviceStatus(
        myDevice.ipAddress,
      );
      if (myDeviceStatus.id != myDevice.deviceId) {
        throw "Device ID does not match";
      }

      emit(
        DeviceItemState.data(
          myDevice.withDevice(
            Device(
              ipAddress: myDevice.ipAddress,
              nodeDeviceStatus: myDeviceStatus,
            ),
          ),
        ),
      );
    } on ClientException {
      emit(DeviceItemState.error("Could not reach device"));
    } on SocketException {
      emit(DeviceItemState.error("Could not reach device"));
    } catch (e) {
      emit(DeviceItemState.error(e.toString()));
    }
  }

  Future<void> _handleUpdateDeviceDataEvent(
    UpdateDeviceData event,
    Emitter<DeviceItemState> emit,
  ) async {
    if (myDevice.device!.nodeDeviceStatus.id !=
        event.device.nodeDeviceStatus.id) {
      // If the device IDs do not match, this is a different device.
      return;
    }

    MyDevice newMyDevice = myDevice.withDevice(event.device);
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
