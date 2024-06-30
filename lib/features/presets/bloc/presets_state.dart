part of 'presets_bloc.dart';

class PresetsState extends BaseState<bool> {
  const PresetsState.loading({bool? data}) : super.loading(data: data);
  const PresetsState.data(bool data) : super.data(data: data);
  const PresetsState.error(String error, {bool? data})
      : super.error(error: error, data: data);
}
