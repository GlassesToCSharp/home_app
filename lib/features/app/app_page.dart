import 'package:flutter/material.dart';
import 'package:home_app/features/app/bloc/app_bloc.dart';
import 'package:home_app/models/bloc_state.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends BlocState<AppPage, AppBloc, AppEvent, AppState> {
  @override
  AppBloc createBloc(KiwiContainer di) {
    return AppBloc(storageService: di.resolve<StorageService>());
  }

  @override
  Widget buildState(BuildContext context, AppState state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // TODO: If we have data, then we should go straight to the main app. If we
    // do not have data, we need to begin the scanning process.
    return Container();
  }
}
