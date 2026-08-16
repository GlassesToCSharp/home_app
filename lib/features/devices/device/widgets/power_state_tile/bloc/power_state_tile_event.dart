part of 'power_state_tile_bloc.dart';

abstract class PowerStateTileEvent extends Equatable {
  const PowerStateTileEvent();

  @override
  List<Object> get props => [];
}

class NewPowerState extends PowerStateTileEvent {
  final bool newState;
  final bool featureState;

  @override
  List<Object> get props => [...super.props, newState, featureState];

  const NewPowerState({required this.newState, required this.featureState});
}
