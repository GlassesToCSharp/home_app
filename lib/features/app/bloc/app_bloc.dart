import 'package:bloc/bloc.dart';
import 'package:home_app/models/base_state.dart';
import 'package:home_app/services/storage_service/storage_service.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final StorageService storageService;

  AppBloc({required this.storageService}) : super(const AppState.loading()) {
    on<LoadAppSettings>(_handleLoadAppSettingsEvent);
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
