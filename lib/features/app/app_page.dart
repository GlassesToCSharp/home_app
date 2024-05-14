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
    // TODO: implement createBloc
    throw UnimplementedError();
  }

  @override
  Widget buildState(BuildContext context, AppState state) {
    return Container();
  }
}
