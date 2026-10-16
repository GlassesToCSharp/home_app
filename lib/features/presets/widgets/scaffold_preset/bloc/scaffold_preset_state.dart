part of 'scaffold_preset_bloc.dart';

class ScaffoldPresetState extends BaseState<Preset> {
  const ScaffoldPresetState.loading({Preset? data}) : super.loading(data: data);
  const ScaffoldPresetState.idle({Preset? data}) : super.idle(data: data);
  const ScaffoldPresetState.data(Preset data) : super.data(data: data);
  const ScaffoldPresetState.error(String error, {Preset? data})
    : super.error(error: error, data: data);
}
