import 'package:equatable/equatable.dart';
import 'package:home_app/models/node_device_status.dart';

export 'package:home_app/models/node_device_status.dart';

class Device extends Equatable {
  final String ipAddress;
  final NodeDeviceStatus? nodeDeviceStatus;

  String get name => nodeDeviceStatus?.name ?? "";
  bool get isNodeDevice => nodeDeviceStatus != null;

  @override
  List<Object?> get props => [name, ipAddress, nodeDeviceStatus];

  const Device({required this.ipAddress, this.nodeDeviceStatus});
}
