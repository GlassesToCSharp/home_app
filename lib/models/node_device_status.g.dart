// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_device_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeDeviceStatus _$NodeDeviceStatusFromJson(Map<String, dynamic> json) =>
    NodeDeviceStatus(
      name: json['name'] as String,
      power: json['power'] as bool?,
      neonBrightness: (json['neonBrightness'] as num?)?.toInt(),
      ledColor: json['ledColor'] == null
          ? null
          : NodeDeviceLedColor.fromJson(
              json['ledColor'] as Map<String, dynamic>),
      motor: json['motor'] == null
          ? null
          : NodeDeviceMotor.fromJson(json['motor'] as Map<String, dynamic>),
    );
