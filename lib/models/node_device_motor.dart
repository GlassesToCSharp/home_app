import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'node_device_motor.g.dart';

// Don't forget to run:
// dart run build_runner build --delete-conflicting-outputs

@JsonSerializable(createToJson: false)
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

  factory NodeDeviceMotor.fromJson(Map<String, dynamic> json) =>
      _$NodeDeviceMotorFromJson(json);

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
