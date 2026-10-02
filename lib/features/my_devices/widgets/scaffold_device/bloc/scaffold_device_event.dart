part of 'scaffold_device_bloc.dart';

abstract class ScaffoldDeviceEvent extends Equatable {
  const ScaffoldDeviceEvent();

  @override
  List<Object> get props => [];
}

class LoadDevice extends ScaffoldDeviceEvent {
  final MyDevice myDevice;

  @override
  List<Object> get props => [...super.props, myDevice];

  const LoadDevice(this.myDevice);
}
