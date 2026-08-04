part of 'preset_bloc.dart';

abstract class PresetEvent extends Equatable {
  const PresetEvent();

  @override
  List<Object> get props => [];
}

class RefreshPresetActions extends PresetEvent {
  const RefreshPresetActions();
}

class AddPresetAction extends PresetEvent {
  final MyDevice myDevice;
  final PresetAction presetAction;

  @override
  List<Object> get props => [...super.props, myDevice, presetAction];

  const AddPresetAction(this.myDevice, this.presetAction);
}

class RemovePresetAction extends PresetEvent {
  final PresetAction presetAction;

  @override
  List<Object> get props => [...super.props, presetAction];

  const RemovePresetAction(this.presetAction);
}

class ExecuteActions extends PresetEvent {
  const ExecuteActions();
}
