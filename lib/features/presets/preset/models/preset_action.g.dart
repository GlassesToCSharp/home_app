// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresetAction _$PresetActionFromJson(Map<String, dynamic> json) => PresetAction(
  id: (json['id'] as num).toInt(),
  presetId: (json['presetId'] as num).toInt(),
  deviceId: (json['deviceId'] as num).toInt(),
  instructionName: $enumDecode(
    _$InstructionNameEnumMap,
    json['instructionName'],
  ),
  instructionValue: (json['instructionValue'] as num).toInt(),
);

Map<String, dynamic> _$PresetActionToJson(PresetAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'presetId': instance.presetId,
      'deviceId': instance.deviceId,
      'instructionName': _$InstructionNameEnumMap[instance.instructionName]!,
      'instructionValue': instance.instructionValue,
    };

const _$InstructionNameEnumMap = {
  InstructionName.power: 'power',
  InstructionName.neonBrightness: 'neonBrightness',
  InstructionName.ledColor: 'ledColor',
  InstructionName.motorAcceleration: 'motorAcceleration',
  InstructionName.motorSpeed: 'motorSpeed',
  InstructionName.motorPosition: 'motorPosition',
};
