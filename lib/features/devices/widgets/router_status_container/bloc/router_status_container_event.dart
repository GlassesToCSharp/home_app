part of 'router_status_container_bloc.dart';

abstract class RouterStatusContainerEvent extends Equatable {
  const RouterStatusContainerEvent();

  @override
  List<Object> get props => [];
}

class GetRouterInfo extends RouterStatusContainerEvent {
  const GetRouterInfo();
}
