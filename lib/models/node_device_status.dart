import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:home_app/models/node_device_motor.dart';

export 'package:home_app/models/node_device_motor.dart';

// TODO: JsonSerialiazable
class NodeDeviceStatus extends Equatable {
  final String name;
  final bool? power;
  final Color? ledColor;
  final NodeDeviceMotor? motor;

  @override
  List<Object?> get props => [name, power, ledColor, motor];

  const NodeDeviceStatus({
    required this.name,
    required this.power,
    required this.ledColor,
    required this.motor,
  });

  // For testing purposes.
  NodeDeviceStatus copyWith({
    String? name,
    bool? power,
    Color? ledColor,
    NodeDeviceMotor? motor,
  }) {
    return NodeDeviceStatus(
      name: name ?? this.name,
      power: power ?? this.power,
      ledColor: ledColor ?? this.ledColor,
      motor: motor ?? this.motor,
    );
  }
}
