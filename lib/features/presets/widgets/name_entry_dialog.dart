import 'package:flutter/material.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';

class NameEntryDialog extends StatelessWidget {
  static const _maxLength = 29;
  final _nameController = TextEditingController();

  final Function(String) onSubmit;
  final int maxLength;

  NameEntryDialog({
    required this.onSubmit,
    this.maxLength = _maxLength,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Preset Name'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(hintText: "Enter preset name"),
        textInputAction: TextInputAction.done,
        maxLength: maxLength,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            onSubmit(_nameController.text);
            NavigationService.pop();
          },
        ),
      ],
    );
    ;
  }
}
