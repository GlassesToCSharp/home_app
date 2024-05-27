import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/widgets/router_status_container/models/router_info.dart';
import 'package:home_app/models/base_state.dart';

part 'router_status_container_event.dart';
part 'router_status_container_state.dart';

class RouterStatusContainerBloc
    extends Bloc<RouterStatusContainerEvent, RouterStatusContainerState> {
  RouterStatusContainerBloc()
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
}
