part of 'motor_control_tile_dialog_bloc.dart';

abstract class MotorControlTileDialogEvent extends Equatable {
  const MotorControlTileDialogEvent();

  @override
  List<Object> get props => [];
}

class NewConfiguration extends MotorControlTileDialogEvent {
  final NodeDeviceMotor newConfiguration;

  @override
  List<Object> get props => [...super.props, newConfiguration];

  const NewConfiguration(this.newConfiguration);
}
