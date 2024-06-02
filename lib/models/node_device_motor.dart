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

  // For testing purposes.
  NodeDeviceMotor copyWith({
    int? speed,
    int? position,
    int? acceleration,
  }) {
    return NodeDeviceMotor(
      speed: speed ?? this.speed,
      position: position ?? this.position,
      acceleration: acceleration ?? this.acceleration,
    );
  }
}
