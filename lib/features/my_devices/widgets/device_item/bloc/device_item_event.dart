part of 'device_item_bloc.dart';

abstract class DeviceItemEvent extends Equatable {
  const DeviceItemEvent();

  @override
  List<Object> get props => [];
}

class GetDeviceData extends DeviceItemEvent {
  const GetDeviceData();
}

class UpdateDeviceData extends DeviceItemEvent {
  final Device device;

  @override
  List<Object> get props => [...super.props, device];

  const UpdateDeviceData(this.device);
}
