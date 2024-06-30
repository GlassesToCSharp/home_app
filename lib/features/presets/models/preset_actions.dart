import 'package:equatable/equatable.dart';
import 'package:home_app/models/node_device_status.dart';

export 'package:home_app/models/node_device_status.dart';

class PresetActions extends Equatable {
  final String name;
  final NodeDeviceStatus newValues;

  @override
  List<Object?> get props => [name, newValues];

  const PresetActions({required this.name, required this.newValues});
}
