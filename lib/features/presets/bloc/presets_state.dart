part of 'presets_bloc.dart';

class PresetsState extends BaseState<List<Preset>> {
  const PresetsState.loading({List<Preset>? data}) : super.loading(data: data);
  const PresetsState.data(List<Preset> data) : super.data(data: data);
  const PresetsState.error(String error, {List<Preset>? data})
    : super.error(error: error, data: data);
}
