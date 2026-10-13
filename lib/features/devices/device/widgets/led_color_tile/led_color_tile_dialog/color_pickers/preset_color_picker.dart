import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class PresetColorPicker extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onChanged;

  const PresetColorPicker({
    required this.color,
    required this.onChanged,
    super.key,
  });

  @override
  State<PresetColorPicker> createState() => _PresetColorPickerState();
}

class _PresetColorPickerState extends State<PresetColorPicker> {
  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      pickersEnabled: {
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.customSecondary: false,
        ColorPickerType.wheel: false,
      },
      // enableOpacity: true,
      onColorChanged: widget.onChanged,
    );
  }
}
