part of 'app_bloc.dart';

class AppState extends BaseState<bool> {
  const AppState.loading({bool? data}) : super.loading(data: data);
  const AppState.data(bool data) : super.data(data: data);
  const AppState.error(String error, {bool? data})
      : super.error(error: error, data: data);
}
