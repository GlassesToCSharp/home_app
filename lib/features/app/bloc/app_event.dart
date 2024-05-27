part of 'app_bloc.dart';

abstract class AppEvent {
  const AppEvent();
}

class LoadAppSettings extends AppEvent {
  const LoadAppSettings();
}

class LoadApp extends AppEvent {
  const LoadApp();
}
