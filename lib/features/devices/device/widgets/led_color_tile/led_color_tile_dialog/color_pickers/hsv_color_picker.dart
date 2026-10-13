import 'package:flutter/material.dart';

import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class HsvColorPicker extends StatefulWidget {
  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;

  const HsvColorPicker({
    required this.color,
    required this.onChanged,
    super.key,
  });

  @override
  State<HsvColorPicker> createState() => _HsvColorPickerState();
}

class _HsvColorPickerState extends State<HsvColorPicker> {
  HSVColor get color => widget.color;

  // Hue
  void hueOnChange(double value) => widget.onChanged(color.withHue(value));
  List<Color> get hueColors => <Color>[
    color.withHue(0.0).toColor(),
    color.withHue(60.0).toColor(),
    color.withHue(120.0).toColor(),
    color.withHue(180.0).toColor(),
    color.withHue(240.0).toColor(),
    color.withHue(300.0).toColor(),
    color.withHue(0.0).toColor(),
  ];

  // Saturation
  void saturationOnChange(double value) =>
      widget.onChanged(color.withSaturation(value));
  List<Color> get saturationColors => <Color>[
    color.withSaturation(0.0).toColor(),
    color.withSaturation(1.0).toColor(),
  ];

  // Value
  void valueOnChange(double value) => widget.onChanged(color.withValue(value));
  List<Color> get valueColors => <Color>[
    color.withValue(0.0).toColor(),
    color.withValue(1.0).toColor(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Hue
        SliderPicker(
          value: color.hue,
          max: 360.0,
          onChanged: hueOnChange,
          colors: hueColors,
        ),

        // Saturation
        SliderPicker(
          value: color.saturation,
          onChanged: saturationOnChange,
          colors: saturationColors,
        ),

        // Value
        SliderPicker(
          value: color.value,
          onChanged: valueOnChange,
          colors: valueColors,
        ),
      ],
    );
  }
}
