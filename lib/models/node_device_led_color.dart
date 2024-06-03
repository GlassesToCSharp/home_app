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

  @override
  List<Object?> get props => [red, green, blue];

  const NodeDeviceLedColor({
    required this.red,
    required this.green,
    required this.blue,
  });

  factory NodeDeviceLedColor.fromJson(Map<String, dynamic> json) =>
      _$NodeDeviceLedColorFromJson(json);

  factory NodeDeviceLedColor.fromColor(Color color) {
    return NodeDeviceLedColor(
      red: color.red,
      green: color.green,
      blue: color.blue,
    );
  }

  // For testing purposes.
  NodeDeviceLedColor copyWith({
    int? red,
    int? green,
    int? blue,
  }) {
    return NodeDeviceLedColor(
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
    );
  }
}
