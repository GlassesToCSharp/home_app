import 'package:bloc/bloc.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/services/connectivity_service/connectivity_service.dart';

export 'package:home_app/services/connectivity_service/connectivity_service.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final ConnectivityService connectivityService;

  AppBloc({required this.connectivityService})
      : super(const AppState.loading()) {
    on<LoadApp>(_handleLoadAppEvent);
  }

  Future<void> _handleLoadAppEvent(
      LoadApp event, Emitter<AppState> emit) async {
    emit(const AppState.loading());

    // Wait for a very short time to show user responsiveness.
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final isWifiConnected =
          await connectivityService.isConnectedToLocalNetwork();
      if (isWifiConnected) {
        emit(AppState.data(isWifiConnected));
        return;
      }
      throw "Device is not connected to WiFi.";
    } catch (e) {
      emit(AppState.error(e.toString(), data: false));
    }
  }
}
