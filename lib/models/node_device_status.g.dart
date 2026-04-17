// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_device_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeDeviceStatus _$NodeDeviceStatusFromJson(Map<String, dynamic> json) =>
    NodeDeviceStatus(
      id: json['id'] as String,
      name: json['name'] as String,
      power: json['power'] as bool?,
      neonBrightness: (json['neon-brightness'] as num?)?.toInt(),
      ledColor: NodeDeviceStatus._intToLedColor(json['led-color']),
      motor: json['motor'] == null
          ? null
          : NodeDeviceMotor.fromJson(json['motor'] as Map<String, dynamic>),
    );
