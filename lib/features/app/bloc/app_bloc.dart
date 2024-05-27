import 'package:bloc/bloc.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/services/storage_service/storage_service.dart';

export 'package:home_app/services/storage_service/storage_service.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final StorageService storageService;

  AppBloc({required this.storageService}) : super(const AppState.loading()) {
    on<LoadApp>(_handleLoadAppEvent);
    on<LoadAppSettings>(_handleLoadAppSettingsEvent);
  }

  Future<void> _handleLoadAppEvent(
      LoadApp event, Emitter<AppState> emit) async {
    emit(const AppState.loading());

    // TODO: Check the device is on WiFi and is connected to a network.
    // For now, return success.
    emit(const AppState.data(true));
  }

  Future<void> _handleLoadAppSettingsEvent(
      LoadAppSettings event, Emitter<AppState> emit) async {
    emit(const AppState.loading());

    try {
      final hasData = await storageService.hasData();
      emit(AppState.data(hasData));
    } catch (e) {
      emit(AppState.error(e.toString()));
    }
  }
}
