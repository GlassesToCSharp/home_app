import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'node_device_led_color.g.dart';

// Don't forget to run:
// dart run build_runner build --delete-conflicting-outputs

@JsonSerializable(createToJson: false)
class NodeDeviceLedColor extends Equatable {
  final int red;
  final int green;
  final int blue;
  final int opacity;

  @override
  List<Object?> get props => [red, green, blue, opacity];

  const NodeDeviceLedColor({
    required this.red,
    required this.green,
    required this.blue,
    required this.opacity,
  });

  factory NodeDeviceLedColor.fromJson(Map<String, dynamic> json) =>
      _$NodeDeviceLedColorFromJson(json);

  factory NodeDeviceLedColor.fromColor(Color color) {
    return NodeDeviceLedColor(
      red: (color.r * 255.0).round().clamp(0, 255),
      green: (color.g * 255.0).round().clamp(0, 255),
      blue: (color.b * 255.0).round().clamp(0, 255),
      opacity: (color.a * 255).round().clamp(0, 255),
    );
  }

  Color toColor() {
    return Color.fromRGBO(red, green, blue, opacity / 255);
  }

  String toHexString() {
    return "#${toColor().toARGB32().toRadixString(16).padLeft(8, "0")}";
  }

  // For testing purposes.
  NodeDeviceLedColor copyWith({int? red, int? green, int? blue, int? opacity}) {
    return NodeDeviceLedColor(
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      opacity: opacity ?? this.opacity,
    );
  }
}
