part of 'router_status_container_bloc.dart';

class RouterStatusContainerState extends BaseState<RouterInfo> {
  const RouterStatusContainerState.loading({RouterInfo? data})
      : super.loading(data: data);
  const RouterStatusContainerState.data(RouterInfo data)
      : super.data(data: data);
  const RouterStatusContainerState.error(String error, {RouterInfo? data})
      : super.error(error: error, data: data);
}
