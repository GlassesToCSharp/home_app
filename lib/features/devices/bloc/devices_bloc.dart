import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:lan_scanner/lan_scanner.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  final NodeDeviceRepository repository;

  DevicesBloc({required this.repository})
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
      final scanner = LanScanner();
      final List<Host> hosts = await scanner.quickIcmpScanAsync('192.168.0');

      // For each device, check whether it is the NodeMCU that we want. If it
      // is, add it to the list to return.
      final devices = <Device>[];
      for (final host in hosts) {
        if (host.internetAddress.type == InternetAddressType.IPv4) {
          try {
            final deviceSatus =
                await repository.getDeviceStatus(host.internetAddress.address);
            devices.add(Device(
                name: deviceSatus.name,
                ipAddress: host.internetAddress.address));
          } catch (_) {
            continue;
          }
        }
      }
    } catch (e) {
      emit(DevicesState.error(e.toString(), data: state.data));
    }
  }
}
