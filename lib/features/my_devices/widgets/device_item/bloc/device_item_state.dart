part of 'device_item_bloc.dart';

class DeviceItemState extends BaseState<MyDevice> {
  const DeviceItemState.loading({MyDevice? data}) : super.loading(data: data);
  const DeviceItemState.idle({MyDevice? data}) : super.idle(data: data);
  const DeviceItemState.data(MyDevice data) : super.data(data: data);
  const DeviceItemState.error(String error, {MyDevice? data})
    : super.error(error: error, data: data);
}
