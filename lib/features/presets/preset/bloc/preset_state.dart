part of 'preset_bloc.dart';

class PresetState extends BaseState<List<PresetAction>> {
  const PresetState.loading({List<PresetAction>? data})
    : super.loading(data: data);
  const PresetState.data(List<PresetAction> data) : super.data(data: data);
  const PresetState.error(String error, {List<PresetAction>? data})
    : super.error(error: error, data: data);
}
