import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:home_app/features/presets/preset/widgets/action_fab/bloc/action_fab_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

export 'package:home_app/features/presets/preset/models/preset_action.dart';

class ActionFab extends StatefulWidget {
  final List<PresetAction>? presetActions;

  const ActionFab({required this.presetActions, super.key});

  @override
  State<ActionFab> createState() => _ActionFabState();
}

class _ActionFabState
    extends
        BlocState<ActionFab, ActionFabBloc, ActionFabEvent, ActionFabState> {
  @override
  ActionFabBloc createBloc(KiwiContainer di) {
    return ActionFabBloc(
      presetActions: widget.presetActions ?? <PresetAction>[],
      dbService: di.resolve<DatabaseService>(),
      repository: di.resolve<NodeDeviceRepository>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.presetActions == null || widget.presetActions!.isEmpty) {
      return const SizedBox();
    }

    return super.build(context);
  }

  @override
  void onStateChange(BuildContext context, ActionFabState newState) {
    super.onStateChange(context, newState);

    if (newState.hasError) {
      SnackBarPresenter.presentError(
        ScaffoldMessenger.of(context),
        newState.error!,
      );
    } else if (newState.hasData && newState.data == true) {
      SnackBarPresenter.presentSuccess(
        ScaffoldMessenger.of(context),
        "Actioned successfully",
      );
    }
  }

  @override
  Widget buildState(BuildContext context, ActionFabState state) {
    return Stack(
      children: [
        if (state.loading) ...[
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withAlpha(0), // required
            ),
          ),
          Center(
            child: Card(
              color: Colors.blueGrey[700],
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    Text(
                      "Executing actions",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (!state.loading)
          FloatingActionButton.extended(
            onPressed: () => bloc.add(const ExecuteActions()),
            label: const Text("Action"),
          ),
      ],
    );
  }
}
