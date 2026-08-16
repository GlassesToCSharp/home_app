part of 'led_color_tile_bloc.dart';

abstract class LedColorTileEvent extends Equatable {
  const LedColorTileEvent();

  @override
  List<Object> get props => [];
}

class UpdateFeatureState extends LedColorTileEvent {
  final bool newFeatureState;

  @override
  List<Object> get props => [...super.props, newFeatureState];

  const UpdateFeatureState(this.newFeatureState);
}
