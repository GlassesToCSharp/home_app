part of 'neon_brightness_tile_bloc.dart';

abstract class NeonBrightnessTileEvent extends Equatable {
  const NeonBrightnessTileEvent();

  @override
  List<Object> get props => [];
}

class UpdateFeatureState extends NeonBrightnessTileEvent {
  final bool newFeatureState;

  @override
  List<Object> get props => [...super.props, newFeatureState];

  const UpdateFeatureState(this.newFeatureState);
}
