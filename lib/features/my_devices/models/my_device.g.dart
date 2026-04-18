// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyDevice _$MyDeviceFromJson(Map<String, dynamic> json) => MyDevice(
  id: (json['id'] as num).toInt(),
  deviceId: json['deviceId'] as String,
  name: json['name'] as String,
  ipAddress: json['ipAddress'] as String,
);

Map<String, dynamic> _$MyDeviceToJson(MyDevice instance) => <String, dynamic>{
  'id': instance.id,
  'deviceId': instance.deviceId,
  'name': instance.name,
  'ipAddress': instance.ipAddress,
};
