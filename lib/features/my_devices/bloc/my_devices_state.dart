part of 'my_devices_bloc.dart';

class MyDevicesState extends BaseState<List<MyDevice>> {
  @override
  bool get hasData => super.hasData && data!.isNotEmpty;

  const MyDevicesState.loading({List<MyDevice>? data})
    : super.loading(data: data);
  const MyDevicesState.idle({List<MyDevice>? data}) : super.idle(data: data);
  const MyDevicesState.data(List<MyDevice> data) : super.data(data: data);
  const MyDevicesState.error(String error, {List<MyDevice>? data})
    : super.error(error: error, data: data);
}
