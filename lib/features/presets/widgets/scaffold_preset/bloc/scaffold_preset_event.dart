part of 'scaffold_preset_bloc.dart';

abstract class ScaffoldPresetEvent extends Equatable {
  const ScaffoldPresetEvent();

  @override
  List<Object> get props => [];
}

class LoadPreset extends ScaffoldPresetEvent {
  final Preset preset;

  @override
  List<Object> get props => [...super.props, preset];

  const LoadPreset(this.preset);
}

class RemovePreset extends ScaffoldPresetEvent {
  final Preset preset;

  @override
  List<Object> get props => [...super.props, preset];

  const RemovePreset(this.preset);
}
