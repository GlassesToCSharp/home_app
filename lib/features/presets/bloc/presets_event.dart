part of 'presets_bloc.dart';

abstract class PresetsEvent extends Equatable {
  const PresetsEvent();

  @override
  List<Object> get props => [];
}

class Execute extends PresetsEvent {
  final NodeDeviceStatus values;

  @override
  List<Object> get props => [values];

  const Execute(this.values);
}
