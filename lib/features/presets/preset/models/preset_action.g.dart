// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresetAction _$PresetActionFromJson(Map<String, dynamic> json) => PresetAction(
  id: (json['id'] as num).toInt(),
  presetId: (json['presetId'] as num).toInt(),
  deviceId: (json['deviceId'] as num).toInt(),
  deviceInstruction: json['deviceInstruction'] as String,
);

Map<String, dynamic> _$PresetActionToJson(PresetAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'presetId': instance.presetId,
      'deviceId': instance.deviceId,
      'deviceInstruction': instance.deviceInstruction,
    };
