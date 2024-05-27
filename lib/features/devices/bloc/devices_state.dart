part of 'devices_bloc.dart';

class DevicesState extends BaseState<DevicesData> {
  const DevicesState.loading({DevicesData? data}) : super.loading(data: data);
  const DevicesState.data(DevicesData data) : super.data(data: data);
  const DevicesState.error(String error, {DevicesData? data})
      : super.error(error: error, data: data);
}
