part of 'devices_bloc.dart';

class DevicesState extends BaseState<List<Device>> {
  final bool enableScan;

  @override
  bool get hasData => super.hasData && data!.isNotEmpty;

  const DevicesState.loading({List<Device>? data, this.enableScan = true})
      : super.loading(data: data);
  const DevicesState.idle({List<Device>? data, this.enableScan = false})
      : super.idle(data: data);
  const DevicesState.data(List<Device> data, {this.enableScan = true})
      : super.data(data: data);
  const DevicesState.error(String error,
      {List<Device>? data, this.enableScan = true})
      : super.error(error: error, data: data);
}
