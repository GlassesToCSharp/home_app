part of 'devices_bloc.dart';

class DevicesState extends BaseState<List<Device>> {
  @override
  bool get hasData => super.hasData && data!.isNotEmpty;

  const DevicesState.loading({List<Device>? data}) : super.loading(data: data);
  const DevicesState.idle({List<Device>? data}) : super.idle(data: data);
  const DevicesState.data(List<Device> data) : super.data(data: data);
  const DevicesState.error(String error, {List<Device>? data})
      : super.error(error: error, data: data);
}
