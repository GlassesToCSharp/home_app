import 'package:flutter/material.dart';

class CentralLoadingIndicator extends StatelessWidget {
  const CentralLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
