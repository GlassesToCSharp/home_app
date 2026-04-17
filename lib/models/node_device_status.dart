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
  final String id;
  final String name;
  final bool? power;
  @JsonKey(name: "neon-brightness")
  final int? neonBrightness;
  @JsonKey(name: "led-color", fromJson: _intToLedColor)
  final NodeDeviceLedColor? ledColor;
  final NodeDeviceMotor? motor;

  @override
  List<Object?> get props => [id, name, power, neonBrightness, ledColor, motor];

  bool get isIdSet => id.isNotEmpty;
  bool get hasPowerState => power != null;
  bool get hasNeonBrightnessState => neonBrightness != null;
  bool get hasLedColorState => ledColor != null;
  bool get hasMotorState => motor != null;

  const NodeDeviceStatus({
    required this.id,
    required this.name,
    required this.power,
    required this.neonBrightness,
    required this.ledColor,
    required this.motor,
  });

  factory NodeDeviceStatus.fromJson(Map<String, dynamic> json) =>
      _$NodeDeviceStatusFromJson(json);

  factory NodeDeviceStatus.empty() => const NodeDeviceStatus(
    id: "",
    name: "",
    power: null,
    neonBrightness: null,
    ledColor: null,
    motor: null,
  );

  // For testing purposes.
  NodeDeviceStatus copyWith({
    String? id,
    String? name,
    bool? power,
    int? neonBrightness,
    NodeDeviceLedColor? ledColor,
    NodeDeviceMotor? motor,
  }) {
    return NodeDeviceStatus(
      id: id ?? this.id,
      name: name ?? this.name,
      power: power ?? this.power,
      neonBrightness: neonBrightness ?? this.neonBrightness,
      ledColor: ledColor ?? this.ledColor,
      motor: motor ?? this.motor,
    );
  }

  static NodeDeviceLedColor _intToLedColor(dynamic color) {
    if (color is! int) {
      throw "Invalid colour object set in JSON";
    }

    return NodeDeviceLedColor(
      opacity: (color >> 24) & 0xFF,
      red: (color >> 16) & 0xFF,
      green: (color >> 8) & 0xFF,
      blue: color & 0xFF,
    );
  }
}
