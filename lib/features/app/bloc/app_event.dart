part of 'app_bloc.dart';

abstract class AppEvent {
  const AppEvent();
}

class LoadApp extends AppEvent {
  const LoadApp();
}
