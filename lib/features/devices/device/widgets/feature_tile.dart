import 'package:flutter/material.dart';

class FeatureTile extends StatefulWidget {
  final String title;
  final bool isConfiguring;
  final bool featureState;
  final void Function(bool) onFeatureStateChange;
  final bool isLoading;
  final Widget child;

  const FeatureTile({
    required this.title,
    required this.isConfiguring,
    required this.featureState,
    required this.onFeatureStateChange,
    required this.isLoading,
    required this.child,
    super.key,
  });

  @override
  State<FeatureTile> createState() => _FeatureTileState();
}

class _FeatureTileState extends State<FeatureTile> {
  bool _featureState = false;

  @override
  void initState() {
    super.initState();

    _featureState = widget.featureState;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isConfiguring) {
      return widget.child;
    }

    return SwitchListTile(
      title: Text(widget.title),
      activeThumbColor: Colors.grey[100],
      activeTrackColor: Theme.of(context).primaryColor,
      inactiveThumbColor: Colors.grey[700],
      inactiveTrackColor: Colors.grey[350],
      value: _featureState,
      onChanged: !widget.isLoading
          ? (newState) {
              widget.onFeatureStateChange(newState);
              setState(() {
                _featureState = newState;
              });
            }
          : null,
    );
  }
}
