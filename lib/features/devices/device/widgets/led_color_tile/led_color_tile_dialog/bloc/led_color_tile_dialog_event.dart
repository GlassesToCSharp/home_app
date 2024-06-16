part of 'led_color_tile_dialog_bloc.dart';

abstract class LedColorTileDialogEvent extends Equatable {
  const LedColorTileDialogEvent();

  @override
  List<Object> get props => [];
}

class NewColor extends LedColorTileDialogEvent {
  final int red;
  final int green;
  final int blue;
  final int opacity;

  @override
  List<Object> get props => [...super.props, red, green, blue, opacity];

  const NewColor(this.red, this.green, this.blue, this.opacity);
}
