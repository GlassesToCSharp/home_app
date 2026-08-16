part of 'motor_control_tile_bloc.dart';

abstract class MotorControlTileEvent extends Equatable {
  const MotorControlTileEvent();

  @override
  List<Object> get props => [];
}

class UpdateFeatureState extends MotorControlTileEvent {
  final bool newFeatureState;

  @override
  List<Object> get props => [...super.props, newFeatureState];

  const UpdateFeatureState(this.newFeatureState);
}
