import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScaffoldHeaderTile extends StatefulWidget {
  final String title;
  // The dialog must close with `Navigator.pop<String>(context, stringData)`
  final Widget Function(BuildContext) edittingDialog;
  final VoidCallback? onSuccess;

  const ScaffoldHeaderTile({
    required this.title,
    required this.edittingDialog,
    this.onSuccess,
  });

  @override
  State<ScaffoldHeaderTile> createState() => _ScaffoldHeaderTileState();
}

class _ScaffoldHeaderTileState extends State<ScaffoldHeaderTile> {
  String _title = "";

  @override
  void initState() {
    super.initState();

    _title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(8),
      child: Row(
        children: [
          Text(_title),
          Spacer(),
          IconButton(
            onPressed: () async {
              final newTitle = await showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: widget.edittingDialog,
              );
              if (newTitle != null && newTitle != _title) {
                setState(() {
                  _title = newTitle;
                });
                if (widget.onSuccess != null) {
                  widget.onSuccess!();
                }
              }
            },
            icon: FaIcon(FontAwesomeIcons.pen, size: 16),
          ),
        ],
      ),
    );
  }
}
