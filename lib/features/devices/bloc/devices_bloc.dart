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
    on<EnableScan>(_handleEnableScanEvent);
    on<ScanForDevices>(_handleScanForDevicesEvent);
  }

  Future<void> _handleEnableScanEvent(
      EnableScan event, Emitter<DevicesState> emit) async {
    if (state.hasError) {
      emit(DevicesState.error(state.error!,
          data: state.data, enableScan: event.enable));
    } else if (state.hasData) {
      emit(DevicesState.data(state.data!, enableScan: event.enable));
    } else if (state.loading) {
      emit(DevicesState.loading(data: state.data, enableScan: event.enable));
    } else {
      emit(DevicesState.idle(data: state.data, enableScan: event.enable));
    }
  }

  Future<void> _handleScanForDevicesEvent(
      ScanForDevices event, Emitter<DevicesState> emit) async {
    emit(const DevicesState.loading());

    try {
      final hosts = await connectivityService.scanForDevices('192.168.0');

      // For each device, check whether it is the NodeMCU that we want. If it
      // is, add it to the list to return.
      final devices = <Device>[];
      for (final host in hosts) {
        try {
          final deviceSatus = await repository.getDeviceStatus(host.ipAddress);
          devices.add(
              Device(nodeDeviceStatus: deviceSatus, ipAddress: host.ipAddress));
        } catch (_) {
          // Ignore errors, and don't add device to list.
          continue;
        }
      }
      emit(DevicesState.data(devices));
    } catch (e) {
      emit(DevicesState.error(e.toString(), data: state.data));
    }
  }
}
