import 'package:flutter/material.dart';
import 'package:home_app/features/app/app.dart';
// import 'package:network_tools/network_tools.dart';
// import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // It's necessary to pass correct path to be able to use this library.
  // final appDocDirectory = await getApplicationDocumentsDirectory();
  // await configureNetworkTools(appDocDirectory.path, enableDebugging: true);
  runApp(const App());
}
