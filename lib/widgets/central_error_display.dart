import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CentralErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final TextStyle? textStyle;

  const CentralErrorDisplay({
    required this.message,
    required this.onRetry,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(FontAwesomeIcons.circleExclamation, size: 32),
          const SizedBox(height: 10),
          Text(
            message,
            style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onRetry,
            style: Theme.of(context).elevatedButtonTheme.style,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
