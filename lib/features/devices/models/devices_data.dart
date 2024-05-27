import 'package:equatable/equatable.dart';
import 'package:home_app/features/devices/models/device.dart';

export 'package:home_app/features/devices/models/device.dart';

class DevicesData extends Equatable {
  final String routerName;
  final List<Device> devices;

  @override
  List<Object?> get props => [routerName, devices];

  const DevicesData({
    required this.routerName,
    required this.devices,
  });
}
