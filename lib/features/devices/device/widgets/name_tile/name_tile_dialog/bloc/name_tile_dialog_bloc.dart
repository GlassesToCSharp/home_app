import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

export 'package:home_app/repositories/node_device_repository/node_device_repository.dart';

part 'name_tile_dialog_event.dart';
part 'name_tile_dialog_state.dart';

class NameTileDialogBloc
    extends Bloc<NameTileDialogEvent, NameTileDialogState> {
  final String deviceIpAddress;
  final NodeDeviceRepository repository;

  NameTileDialogBloc({
    required this.deviceIpAddress,
    required this.repository,
  }) : super(const NameTileDialogState.data(false)) {
    on<NewName>(_handleNewNameEvent);
  }

  Future<void> _handleNewNameEvent(
      NewName event, Emitter<NameTileDialogState> emit) async {
    emit(NameTileDialogState.loading(data: state.data));

    try {
      await repository.setDeviceName(deviceIpAddress, event.newName);
      emit(const NameTileDialogState.data(true));
    } catch (e) {
      emit(NameTileDialogState.error(e.toString(), data: false));
    }
  }
}
