part of 'scaffold_preset_actions_bloc.dart';

class ScaffoldPresetActionsState extends BaseState<List<PresetAction>> {
  const ScaffoldPresetActionsState.loading({List<PresetAction>? data})
    : super.loading(data: data);
  const ScaffoldPresetActionsState.data(List<PresetAction> data)
    : super.data(data: data);
  const ScaffoldPresetActionsState.error(
    String error, {
    List<PresetAction>? data,
  }) : super.error(error: error, data: data);
}
