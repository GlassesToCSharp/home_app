import 'package:flutter/material.dart';

class ScaffoldHeaderTileDialog extends StatefulWidget {
  final String title;
  final bool isLoading;
  final Function(String) onSave;

  const ScaffoldHeaderTileDialog({
    required this.title,
    required this.isLoading,
    required this.onSave,
    super.key,
  });

  @override
  State<ScaffoldHeaderTileDialog> createState() =>
      _ScaffoldHeaderTileDialogState();
}

class _ScaffoldHeaderTileDialogState extends State<ScaffoldHeaderTileDialog> {
  final _textEditingController = TextEditingController();

  bool _hasValueChanged = false;

  @override
  void initState() {
    super.initState();

    _textEditingController.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New device name"),
      content: TextField(
        autocorrect: false,
        autofocus: true,
        controller: _textEditingController,
        maxLength: 19,
        onChanged: (_) {
          setState(() {
            _hasValueChanged = true;
          });
        },
      ),
      actions: widget.isLoading
          ? [const CircularProgressIndicator()]
          : [
              // Negative action
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),

              // Positive action
              TextButton(
                onPressed: _hasValueChanged
                    ? () => widget.onSave(_textEditingController.text)
                    : null,
                child: const Text("Save"),
              ),
            ],
    );
  }
}
