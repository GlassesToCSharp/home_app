import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/bloc/devices_bloc.dart';
import 'package:home_app/features/devices/widgets/router_status_container/models/router_info.dart';
import 'package:home_app/models/base_state.dart';

export 'package:home_app/features/devices/bloc/devices_bloc.dart';

part 'router_status_container_event.dart';
part 'router_status_container_state.dart';

class RouterStatusContainerBloc
    extends Bloc<RouterStatusContainerEvent, RouterStatusContainerState> {
  final DevicesBloc devicesBloc;

  RouterStatusContainerBloc({required this.devicesBloc})
      : super(const RouterStatusContainerState.loading()) {
    on<GetRouterInfo>(_handleGetRouterInfoEvent);
  }

  Future<void> _handleGetRouterInfoEvent(
      GetRouterInfo event, Emitter<RouterStatusContainerState> emit) async {
    emit(const RouterStatusContainerState.loading());

    try {
      // TODO: Get router info
    } catch (e) {
      emit(RouterStatusContainerState.error(e.toString(), data: state.data));
    }
  }

  @override
  void onChange(Change<RouterStatusContainerState> change) {
    super.onChange(change);

    if ((!change.currentState.hasData && change.nextState.hasData) ||
        (change.currentState.hasData && !change.nextState.hasData) ||
        (change.currentState.hasData &&
            change.nextState.hasData &&
            change.currentState.data! != change.nextState.data!)) {
      devicesBloc.add(const ScanForDevices());
    }
  }
}
