import 'package:flutter/material.dart';
import 'package:home_app/features/app/bloc/app_bloc.dart';
import 'package:home_app/features/home/home_page.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends BlocState<AppPage, AppBloc, AppEvent, AppState> {
  @override
  AppEvent? get initialEvent => const LoadApp();

  @override
  AppBloc createBloc(KiwiContainer di) {
    return AppBloc(connectivityService: di.resolve<ConnectivityService>());
  }

  @override
  Widget buildState(BuildContext context, AppState state) {
    if (state.hasError) {
      return CentralErrorDisplay(
        message: state.error!,
        textStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.white),
        onRetry: () => bloc.add(const LoadApp()),
      );
    }

    if (state.loading) {
      return const CentralLoadingIndicator();
    }

    return HomePage();
  }
}
