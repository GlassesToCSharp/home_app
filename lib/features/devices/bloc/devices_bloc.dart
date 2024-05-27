import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/models/devices_data.dart';
import 'package:home_app/models/base_state.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc() : super(const DevicesState.loading()) {
    on<DevicesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
