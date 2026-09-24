import 'package:flutter/material.dart';
import 'package:home_app/features/app/app.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Must add this line.
  await windowManager.ensureInitialized();

  // WindowOptions windowOptions = WindowOptions(
  //   size: Size(800, 600),
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.hidden,
  // );
  const windowOptions = WindowOptions(
    // fullScreen: true,
    // The size of the RasPi pixels
    size: Size(1280, 720),
    // Hide the window bar
    titleBarStyle: TitleBarStyle.hidden,
    center: true, // Optional: center the window before going fullscreen
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(App());
}
