part of 'scaffold_preset_actions_bloc.dart';

abstract class ScaffoldPresetActionsEvent extends Equatable {
  const ScaffoldPresetActionsEvent();

  @override
  List<Object> get props => [];
}

class LoadPresetActions extends ScaffoldPresetActionsEvent {
  final Preset preset;

  @override
  List<Object> get props => [...super.props, preset];

  const LoadPresetActions(this.preset);
}
