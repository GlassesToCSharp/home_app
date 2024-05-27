import 'package:equatable/equatable.dart';

// TODO: JsonSerialiazable
class NodeDeviceMotor extends Equatable {
  final int speed;
  final int position;
  final int acceleration;

  @override
  List<Object?> get props => [speed, position, acceleration];

  const NodeDeviceMotor({
    required this.speed,
    required this.position,
    required this.acceleration,
  });
}
