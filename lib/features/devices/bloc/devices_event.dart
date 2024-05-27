part of 'devices_bloc.dart';

abstract class DevicesEvent extends Equatable {
  const DevicesEvent();

  @override
  List<Object> get props => [];
}

class EnableScan extends DevicesEvent {
  final bool enable;

  const EnableScan(this.enable);
}

class ScanForDevices extends DevicesEvent {
  const ScanForDevices();
}
