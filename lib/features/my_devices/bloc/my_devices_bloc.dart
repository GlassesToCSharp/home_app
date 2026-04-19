import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/my_devices/models/my_device.dart';
import 'package:home_app/mixins/device_utils.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';
export 'package:home_app/services/database_service/database_service.dart';

part 'my_devices_event.dart';
part 'my_devices_state.dart';

class MyDevicesBloc extends Bloc<MyDevicesEvent, MyDevicesState>
    with DeviceUtils {
  final NodeDeviceRepository repository;
  final DatabaseService dbService;

  MyDevicesBloc({required this.repository, required this.dbService})
    : super(MyDevicesState.loading()) {
    on<GetMyDevices>(_handleGetMyDevicesEvent);
    on<AddToMyDevices>(_handleAddToMyDevices);
    on<RemoveFromMyDevices>(_handleRemoveFromMyDevices);
  }

  Future<void> _handleGetMyDevicesEvent(
    MyDevicesEvent event,
    Emitter<MyDevicesState> emit,
  ) async {
    emit(MyDevicesState.loading(data: state.data));

    try {
      final myDevices = await MyDevice.instance().getAll(dbService);
      // Check the devices are online and get the latest state of those devices.
      // Use the /status endpoint for this.
      final statusCalls = <Future>[];
      for (final myDevice in myDevices) {
        statusCalls.add(
          Future(() async {
            try {
              return await repository.getDeviceStatus(myDevice.ipAddress);
            } catch (e) {
              // If retrieving the device status fails, enter empty null device
              // status.
              return NodeDeviceStatus.empty();
            }
          }),
        );
      }

      final statusCallsResults = await Future.wait(statusCalls);
      for (int i = 0; i < statusCallsResults.length; i++) {
        myDevices[i].withDevice(
          myDevices[i].toDevice().withDeviceStatus(statusCallsResults[i]),
        );
      }

      emit(MyDevicesState.data(myDevices));
    } catch (e) {
      emit(MyDevicesState.error(e.toString(), data: state.data));
    }
  }

  Future<void> _handleAddToMyDevices(
    AddToMyDevices event,
    Emitter<MyDevicesState> emit,
  ) async {
    // No loading, just do it.

    try {
      MyDevice myDevice = MyDevice.fromDevice(event.newDevice);

      if (!myDevice.device!.isNodeDevice) {
        throw "Only Node devices can be added";
      }

      // If a device ID has not been set, set it. Maximum length is 3 chars.
      if (myDevice.device!.nodeDeviceStatus.id.isEmpty) {
        final newId = getRandomString(3);
        await repository.setDeviceId(myDevice.ipAddress, newId);
        myDevice = myDevice.copyWith(deviceId: newId);
      }
      await myDevice.insert(dbService);

      // Reload the list
      add(const GetMyDevices());
    } catch (e) {
      emit(MyDevicesState.error(e.toString(), data: state.data));
    }
  }

  Future<void> _handleRemoveFromMyDevices(
    RemoveFromMyDevices event,
    Emitter<MyDevicesState> emit,
  ) async {
    // No loading, just do it.

    try {
      await event.myDevice.delete(dbService);

      // Reload the list
      add(const GetMyDevices());
    } catch (e) {
      emit(MyDevicesState.error(e.toString(), data: state.data));
    }
  }
}
