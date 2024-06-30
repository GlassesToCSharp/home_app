import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/features/devices/models/device.dart';
export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'presets_event.dart';
part 'presets_state.dart';

class PresetsBloc extends Bloc<PresetsEvent, PresetsState> {
  final Set<Device> devices;
  final NodeDeviceRepository repository;

  PresetsBloc({required this.devices, required this.repository})
      : super(const PresetsState.data(false)) {
    on<Execute>(_handleExecuteEvent);
  }

  Future _handleExecuteEvent(Execute event, Emitter<PresetsState> emit) async {
    emit(const PresetsState.loading(data: false));

    try {
      // Each device will queue up the list of actions to take *synchronously*
      // for each device. However, all devices will be actioned on
      // *simultaneously*.
      final allFutures = <Future>[];
      for (final device in devices) {
        final futures = <Future Function()>[];
        if (event.values.hasNeonBrightnessState) {
          futures.add(() => repository.setNeonBrightness(
              device.ipAddress, event.values.neonBrightness!));
        }
        if (event.values.hasLedColorState) {
          futures.add(() => repository.setLedColor(
              device.ipAddress,
              event.values.ledColor!.red,
              event.values.ledColor!.green,
              event.values.ledColor!.blue,
              event.values.ledColor!.opacity));
        }
        if (event.values.hasPowerState) {
          futures.add(() =>
              repository.setPowerState(device.ipAddress, event.values.power!));
        }
        if (event.values.hasMotorState) {
          futures.add(() => repository.setMotorSpeed(
              device.ipAddress, event.values.motor!.speed));
          futures.add(() => repository.setMotorAcceleration(
              device.ipAddress, event.values.motor!.acceleration));
          futures.add(() => repository.setMotorPosition(
              device.ipAddress, event.values.motor!.position));
        }

        allFutures.add(Future.forEach<Future Function()>(
            futures, (call) async => await call()));
      }

      await Future.wait(allFutures);
      emit(const PresetsState.data(true));
    } catch (e) {
      emit(PresetsState.error(e.toString(), data: false));
    }
  }
}
