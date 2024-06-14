part of 'neon_brightness_tile_dialog_bloc.dart';

abstract class NeonBrightnessTileDialogEvent extends Equatable {
  const NeonBrightnessTileDialogEvent();

  @override
  List<Object> get props => [];
}

class NewBrightness extends NeonBrightnessTileDialogEvent {
  final double brightness;

  const NewBrightness(this.brightness);
}
