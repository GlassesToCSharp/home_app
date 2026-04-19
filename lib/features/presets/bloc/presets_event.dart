part of 'presets_bloc.dart';

abstract class PresetsEvent extends Equatable {
  const PresetsEvent();

  @override
  List<Object> get props => [];
}

class GetPresets extends PresetsEvent {
  const GetPresets();
}
