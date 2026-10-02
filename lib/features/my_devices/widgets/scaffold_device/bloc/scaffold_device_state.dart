part of 'scaffold_device_bloc.dart';

class ScaffoldDeviceState extends BaseState<MyDevice> {
  const ScaffoldDeviceState.loading({MyDevice? data})
    : super.loading(data: data);
  const ScaffoldDeviceState.idle({MyDevice? data}) : super.idle(data: data);
  const ScaffoldDeviceState.data(MyDevice data) : super.data(data: data);
  const ScaffoldDeviceState.error(String error, {MyDevice? data})
    : super.error(error: error, data: data);
}
