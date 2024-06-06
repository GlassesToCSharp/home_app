import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum QuickDialogsTheme {
  platformSpecific,
  materialOnly,
  cupertinoOnly,
}

class QuickDialogs {
  /// Gets or sets the overall app dialog theme. This defaults to "platform
  /// specific", meaning `QuickDialogs` will automatically determine whether to
  /// user Cupertino-style dialogs for iOS, or Material-style dialogs for
  /// Android.
  static QuickDialogsTheme dialogTheme = QuickDialogsTheme.platformSpecific;

  // Prevent multiple instances of QuickDialogs class being created.
  QuickDialogs._();

  /// Creates a dialog with the option for a destructive action.
  /// [context] is required to build the dialog
  /// [title] and [message] make up the dialog content
  /// [destructiveActionName] will be an *uppercased* option on the dialog given in a red font.
  /// [destructiveActionCallback] is the callback from the above action.
  /// As well as the destructive action, there will be a "Cancel" option given
  static void destructive(
    BuildContext context, {
    required String title,
    required String message,
    required String constructiveActionName,
    required String destructiveActionName,
    VoidCallback? destructiveActionCallback,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return _PlatformAlertDialog.stringContent(
            title: title,
            content: message,
            actions: <Widget>[
              TextButton(
                child: Text(
                  constructiveActionName.toUpperCase(),
                  style: const TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  // Close the dialog.
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(destructiveActionName.toUpperCase(),
                    style: const TextStyle(color: Colors.red)),
                onPressed: () {
                  // Close the dialog.
                  Navigator.of(context).pop();

                  if (destructiveActionCallback != null) {
                    destructiveActionCallback();
                  }
                },
              )
            ],
          );
        });
  }

  /// Display a standard information dialog.
  static void infoDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onOkClicked,
    String okButton = "OK",
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _PlatformAlertDialog.stringContent(
            title: title,
            content: message,
            actions: <Widget>[
              _PlatformDialogButton.stringContent(
                text: okButton,
                onPressed: () {
                  // Dialog is part of the Navigator.
                  // This will just close the *dialog*.
                  Navigator.pop(context);

                  if (onOkClicked != null) {
                    onOkClicked();
                  }
                },
              ),
            ],
          );
        });
  }

  /// Display a confirmation dialog, and set the required positive and negative
  /// buttons texts.
  static Future<bool?> confirmationDialogAsync(
    BuildContext context, {
    required String title,
    required String message,
    required String positiveButtonText,
    required String negativeButtonText,
  }) async {
    final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return _PlatformAlertDialog.stringContent(
            title: title,
            content: message,
            actions: <Widget>[
              _PlatformDialogButton.stringContent(
                text: negativeButtonText,
                onPressed: () {
                  // Dialog is part of the Navigator.
                  // This will just close the *dialog*.
                  Navigator.pop(context, false);
                },
              ),
              _PlatformDialogButton.stringContent(
                text: positiveButtonText,
                onPressed: () {
                  // Return true for confirmation
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });

    return result;
  }
}

class _PlatformAlertDialog extends StatelessWidget {
  final String title;

  //String content;
  final Widget contentWidget;
  final List<Widget> actions;

  _PlatformAlertDialog.stringContent(
      {required String title,
      required String content,
      required List<Widget> actions})
      : this.widgetContent(
            title: title, actions: actions, contentWidget: Text(content));

  const _PlatformAlertDialog.widgetContent(
      {required this.title,
      required this.contentWidget,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    switch (QuickDialogs.dialogTheme) {
      case QuickDialogsTheme.cupertinoOnly:
        return _createCupertinoDialog(title, contentWidget, actions);

      case QuickDialogsTheme.materialOnly:
        return _createMaterialDialog(title, contentWidget, actions);

      case QuickDialogsTheme.platformSpecific:
      default:
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return _createCupertinoDialog(title, contentWidget, actions);
        } else {
          return _createMaterialDialog(title, contentWidget, actions);
        }
    }
  }

  Widget _createCupertinoDialog(
      String title, Widget contentWidget, List<Widget> actions) {
    return CupertinoAlertDialog(
      title: title.isEmpty ? null : Text(title),
      content: contentWidget,
      actions: actions,
    );
  }

  Widget _createMaterialDialog(
      String title, Widget contentWidget, List<Widget> actions) {
    return AlertDialog(
      title: Text(title),
      content: contentWidget,
      actions: actions,
    );
  }
}

class _PlatformDialogButton extends StatelessWidget {
  final Widget textWidget;
  final VoidCallback onPressed;

  _PlatformDialogButton.stringContent(
      {required String text, required VoidCallback onPressed})
      : this.widgetContent(textWidget: Text(text), onPressed: onPressed);

  const _PlatformDialogButton.widgetContent(
      {required this.textWidget, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    switch (QuickDialogs.dialogTheme) {
      case QuickDialogsTheme.cupertinoOnly:
        return _createCupertinoAction(textWidget, onPressed);

      case QuickDialogsTheme.materialOnly:
        return _createMaterialAction(textWidget, onPressed);

      case QuickDialogsTheme.platformSpecific:
      default:
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return _createCupertinoAction(textWidget, onPressed);
        } else {
          return _createMaterialAction(textWidget, onPressed);
        }
    }
  }

  Widget _createCupertinoAction(Widget textWidget, VoidCallback onPressed) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: textWidget,
    );
  }

  Widget _createMaterialAction(Widget textWidget, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: textWidget,
    );
  }
}
