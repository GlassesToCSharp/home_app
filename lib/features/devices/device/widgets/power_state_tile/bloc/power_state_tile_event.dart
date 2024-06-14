part of 'power_state_tile_bloc.dart';

abstract class PowerStateTileEvent extends Equatable {
  const PowerStateTileEvent();

  @override
  List<Object> get props => [];
}

class NewPowerState extends PowerStateTileEvent {
  final bool newState;

  const NewPowerState(this.newState);
}
