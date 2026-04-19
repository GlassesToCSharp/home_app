import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/services/database_service/database_service.dart';

export 'package:home_app/services/database_service/database_service.dart';

part 'presets_event.dart';
part 'presets_state.dart';

class PresetsBloc extends Bloc<PresetsEvent, PresetsState> {
  final DatabaseService dbService;

  PresetsBloc({required this.dbService}) : super(const PresetsState.loading()) {
    // on<Execute>(_handleExecuteEvent);
    on<GetPresets>(_handleGetPresetsEvent);
    on<CreatePreset>(_handleCreatePresetEvent);
    on<RemovePreset>(_handleRemovePresetEvent);
  }

  // Future _handleExecuteEvent(Execute event, Emitter<PresetsState> emit) async {
  //   emit(const PresetsState.loading(data: false));

  //   try {
  //     // Each device will queue up the list of actions to take *synchronously*
  //     // for each device. However, all devices will be actioned on
  //     // *simultaneously*.
  //     final allFutures = <Future>[];
  //     for (final device in []) {
  //       final futures = <Future Function()>[];
  //       if (event.values.hasNeonBrightnessState) {
  //         futures.add(
  //           () => repository.setNeonBrightness(
  //             device.ipAddress,
  //             event.values.neonBrightness!,
  //           ),
  //         );
  //       }
  //       if (event.values.hasLedColorState) {
  //         futures.add(
  //           () => repository.setLedColor(
  //             device.ipAddress,
  //             event.values.ledColor!.red,
  //             event.values.ledColor!.green,
  //             event.values.ledColor!.blue,
  //             event.values.ledColor!.opacity,
  //           ),
  //         );
  //       }
  //       if (event.values.hasPowerState) {
  //         futures.add(
  //           () =>
  //               repository.setPowerState(device.ipAddress, event.values.power!),
  //         );
  //       }
  //       if (event.values.hasMotorState) {
  //         futures.add(
  //           () => repository.setMotorSpeed(
  //             device.ipAddress,
  //             event.values.motor!.speed,
  //           ),
  //         );
  //         futures.add(
  //           () => repository.setMotorAcceleration(
  //             device.ipAddress,
  //             event.values.motor!.acceleration,
  //           ),
  //         );
  //         futures.add(
  //           () => repository.setMotorPosition(
  //             device.ipAddress,
  //             event.values.motor!.position,
  //           ),
  //         );
  //       }

  //       allFutures.add(
  //         Future.forEach<Future Function()>(
  //           futures,
  //           (call) async => await call(),
  //         ),
  //       );
  //     }

  //     await Future.wait(allFutures);
  //     emit(const PresetsState.data(true));
  //   } catch (e) {
  //     emit(PresetsState.error(e.toString(), data: false));
  //   }
  // }

  Future<void> _handleGetPresetsEvent(
    GetPresets event,
    Emitter<PresetsState> emit,
  ) async {
    emit(const PresetsState.loading());

    try {
      final presets = await Preset.instance().getAll(dbService);
      emit(PresetsState.data(presets));
    } catch (e) {
      emit(PresetsState.error(e.toString()));
    }
  }

  Future<void> _handleCreatePresetEvent(
    CreatePreset event,
    Emitter<PresetsState> emit,
  ) async {
    try {
      // Check name does not exceed max length in DB.
      if (event.name.length > 29) {
        throw "Name is too long";
      }

      // Setting ID to 0 doesn't matter. It will get updated anyway on DB entry.
      Preset newPreset = Preset(id: 0, name: event.name);
      newPreset = await newPreset.insert(dbService);

      final presets = List<Preset>.from(state.data ?? <Preset>[]);
      presets.add(newPreset);
      emit(PresetsState.data(presets));
    } catch (e) {
      emit(PresetsState.error(e.toString()));
    }
  }

  Future<void> _handleRemovePresetEvent(
    RemovePreset event,
    Emitter<PresetsState> emit,
  ) async {
    try {
      await event.preset.delete(dbService);

      final presets = List<Preset>.from(state.data ?? <Preset>[]);
      presets.remove(event.preset);
      emit(PresetsState.data(presets));
    } catch (e) {
      emit(PresetsState.error(e.toString()));
    }
  }
}
