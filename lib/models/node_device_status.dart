import 'package:equatable/equatable.dart';
import 'package:home_app/models/node_device_led_color.dart';
import 'package:home_app/models/node_device_motor.dart';
import 'package:json_annotation/json_annotation.dart';

export 'package:home_app/models/node_device_led_color.dart';
export 'package:home_app/models/node_device_motor.dart';

part 'node_device_status.g.dart';

// Don't forget to run:
// dart run build_runner build --delete-conflicting-outputs

@JsonSerializable(createToJson: false)
class NodeDeviceStatus extends Equatable {
  final String name;
  final bool? power;
  final int? neonBrightness;
  final NodeDeviceLedColor? ledColor;
  final NodeDeviceMotor? motor;

  @override
  List<Object?> get props => [name, power, neonBrightness, ledColor, motor];

  const NodeDeviceStatus({
    required this.name,
    required this.power,
    required this.neonBrightness,
    required this.ledColor,
    required this.motor,
  });

  factory NodeDeviceStatus.fromJson(Map<String, dynamic> json) =>
      _$NodeDeviceStatusFromJson(json);

  // For testing purposes.
  NodeDeviceStatus copyWith({
    String? name,
    bool? power,
    int? neonBrightness,
    NodeDeviceLedColor? ledColor,
    NodeDeviceMotor? motor,
  }) {
    return NodeDeviceStatus(
      name: name ?? this.name,
      power: power ?? this.power,
      neonBrightness: neonBrightness ?? this.neonBrightness,
      ledColor: ledColor ?? this.ledColor,
      motor: motor ?? this.motor,
    );
  }
}
