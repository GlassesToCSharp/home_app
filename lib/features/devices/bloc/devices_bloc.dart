import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/connectivity_service/connectivity_service.dart';
import 'package:network_tools/network_tools.dart';

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
      ScanForDevices event, Emitter<DevicesState> emit) async {
    emit(const DevicesState.loading());

    try {
      // For each device, check whether it is the NodeMCU that we want. If it
      // is, add it to the list to return.
      final devices = <Device>[];
      final nodeDeviceStatus = <Future<NodeDeviceStatus>>[];
      final mdnsDevices = await MdnsScannerService.instance.searchMdnsDevices();
      for (final mdnsDevice in mdnsDevices) {
        final mdnsInfo = await mdnsDevice.mdnsInfo;
        if (mdnsInfo == null) {
          continue;
        }
        final mdnsName = mdnsInfo.getOnlyTheStartOfMdnsName();
        print('''
        Address: ${mdnsDevice.address}
        Port: ${mdnsInfo.mdnsPort}
        ServiceType: ${mdnsInfo.mdnsServiceType}
        MdnsName: ${mdnsInfo.getOnlyTheStartOfMdnsName()}
        ''');
        // Do anything with the active host
        if (mdnsName == "LocalNodeMCU4IoT") {
          try {
            nodeDeviceStatus
                .add(repository.getDeviceStatus(mdnsDevice.address));
            devices.add(Device(ipAddress: "${mdnsDevice.address}:80"));
          } catch (_) {
            // Ignore errors, and don't add device to list.
            continue;
          }
        }
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
