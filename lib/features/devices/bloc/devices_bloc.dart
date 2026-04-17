import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/connectivity_service/connectivity_service.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
export 'package:home_app/services/connectivity_service/connectivity_service.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  final NodeDeviceRepository repository;
  final ConnectivityService connectivityService;

  DevicesBloc({required this.repository, required this.connectivityService})
    : super(const DevicesState.idle(data: <Device>[])) {
    on<ScanForDevices>(_handleScanForDevicesEvent);
  }

  Future<void> _handleScanForDevicesEvent(
    ScanForDevices event,
    Emitter<DevicesState> emit,
  ) async {
    emit(const DevicesState.loading());

    try {
      // For each device, check whether it is the NodeMCU that we want. If it
      // is, add it to the list to return.
      final devices = <Device>[];
      final nodeDeviceStatus = <Future<NodeDeviceStatus>>[];
      final nodeDevices = await connectivityService.scanForDevices();
      for (final nodeDevice in nodeDevices) {
        nodeDeviceStatus.add(
          Future(() async {
            try {
              return await repository.getDeviceStatus(nodeDevice.ipAddress);
            } catch (e) {
              // If retrieving the device status fails, enter empty null device
              // status.
              return NodeDeviceStatus.empty().copyWith(
                name: "[E] ${e.toString()}",
              );
            }
          }),
        );
        devices.add(
          Device(
            ipAddress: nodeDevice.ipAddress,
            nodeDeviceStatus: NodeDeviceStatus.empty(),
          ),
        );
      }

      final statuses = await Future.wait(nodeDeviceStatus);
      for (int i = 0; i < statuses.length; i++) {
        devices[i] = devices[i].withDeviceStatus(statuses[i]);
      }

      emit(DevicesState.data(devices));
    } catch (e) {
      emit(DevicesState.error(e.toString(), data: state.data));
    }
  }
}
