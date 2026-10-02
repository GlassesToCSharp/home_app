import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/presets/models/preset.dart';

export 'package:home_app/features/presets/models/preset.dart';

class PresetItem extends StatefulWidget {
  static const maxItemSize = 150.0;
  static const _iconSize = 16.0;

  final Preset preset;
  final Function(Preset) onTap;
  final FaIconData icon;
  final double maxSize;

  const PresetItem({
    required this.preset,
    required this.onTap,
    this.icon = FontAwesomeIcons.circleExclamation,
    this.maxSize = maxItemSize,
    super.key,
  });

  @override
  State<PresetItem> createState() => _PresetItemState();
}

class _PresetItemState extends State<PresetItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxSize,
      width: widget.maxSize,
      child: Card(
        child: InkWell(
          onTap: () {
            widget.onTap(widget.preset);
            // NavigationService.pop();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.preset.name),
                Expanded(child: Center(child: FaIcon(widget.icon))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
