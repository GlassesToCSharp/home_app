part of 'device_item_bloc.dart';

class DeviceItemState extends BaseState<Device> {
  const DeviceItemState.loading({Device? data}) : super.loading(data: data);
  const DeviceItemState.idle({Device? data}) : super.idle(data: data);
  const DeviceItemState.data(Device data) : super.data(data: data);
  const DeviceItemState.error(String error, {Device? data})
    : super.error(error: error, data: data);
}
