part of 'presets_bloc.dart';

abstract class PresetsEvent extends Equatable {
  const PresetsEvent();

  @override
  List<Object> get props => [];
}

class GetPresets extends PresetsEvent {
  const GetPresets();
}

class CreatePreset extends PresetsEvent {
  final String name;

  @override
  List<Object> get props => [...super.props, name];

  const CreatePreset(this.name);
}

class RemovePreset extends PresetsEvent {
  final Preset preset;

  @override
  List<Object> get props => [...super.props, preset];

  const RemovePreset(this.preset);
}
