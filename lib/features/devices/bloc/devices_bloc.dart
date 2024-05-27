import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/base_state.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc() : super(const DevicesState.loading()) {
    on<ScanForDevices>(_handleScanForDevicesEvent);
  }

  Future<void> _handleScanForDevicesEvent(
      ScanForDevices event, Emitter<DevicesState> emit) async {
    emit(const DevicesState.loading());

    try {
      // TODO: Scan for devices
    } catch (e) {
      emit(DevicesState.error(e.toString(), data: state.data));
    }
  }
}
