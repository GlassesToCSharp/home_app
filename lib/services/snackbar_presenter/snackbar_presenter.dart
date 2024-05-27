import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const _successColor = Color(0xff4dd662);
const _errorColor = Color(0xffed6e73);
const _separationDistance = 12.0;

class SnackBarPresenter {
  const SnackBarPresenter._();

  /// Present an information [SnackBar] in the provided [Scaffold].
  static void presentInformation(
      ScaffoldMessengerState scaffoldMessengerState, String message,
      {Color? iconColor}) {
    // If the `iconColor` is null, it will default to the icon theme data color.
    _presentSnackbar(
      scaffoldMessengerState,
      message,
      iconColor,
      FontAwesomeIcons.circleInfo,
    );
  }

  /// Present a success [SnackBar] in the provided [Scaffold].
  static void presentSuccess(
      ScaffoldMessengerState scaffoldMessengerState, String message,
      {Color? iconColor}) {
    _presentSnackbar(
      scaffoldMessengerState,
      message,
      iconColor ?? _successColor,
      FontAwesomeIcons.solidCircleCheck,
    );
  }

  /// Present an error [SnackBar] in the provided [Scaffold].
  static void presentError(
      ScaffoldMessengerState scaffoldMessengerState, String error,
      {Color? iconColor}) {
    _presentSnackbar(
      scaffoldMessengerState,
      error,
      iconColor ?? _errorColor,
      FontAwesomeIcons.circleExclamation,
    );
  }

  /// Handles displaying the action [SnackBar] with its contents.
  static void _presentSnackbar(ScaffoldMessengerState scaffoldMessengerState,
      String message, Color? color, IconData icon) {
    assert(message.isNotEmpty);
    final snackbar = SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: _separationDistance),
          Expanded(
            child: Text(message),
          ),
        ],
      ),
    );

    // Hide any currently showing SnackBars. If there are none, this will do
    // nothing.
    scaffoldMessengerState.hideCurrentSnackBar();

    scaffoldMessengerState.showSnackBar(snackbar);
  }
}
