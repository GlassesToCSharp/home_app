import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  static const maxItemSize = 150.0;

  final VoidCallback onTap;
  final double maxSize;
  final List<Widget> children;

  const CustomListItem({
    required this.onTap,
    required this.children,
    this.maxSize = maxItemSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxSize,
      width: maxSize,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
