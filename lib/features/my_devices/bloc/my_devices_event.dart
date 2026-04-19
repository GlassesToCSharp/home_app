part of 'my_devices_bloc.dart';

abstract class MyDevicesEvent extends Equatable {
  const MyDevicesEvent();

  @override
  List<Object> get props => [];
}

class GetMyDevices extends MyDevicesEvent {
  const GetMyDevices();
}

class AddToMyDevices extends MyDevicesEvent {
  final Device newDevice;

  const AddToMyDevices(this.newDevice);

  @override
  List<Object> get props => [...super.props, newDevice];
}

class RemoveFromMyDevices extends MyDevicesEvent {
  final MyDevice myDevice;

  const RemoveFromMyDevices(this.myDevice);

  @override
  List<Object> get props => [...super.props, myDevice];
}
