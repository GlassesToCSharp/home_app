import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/my_devices/my_devices_navigator.dart';
import 'package:home_app/features/presets/preset/bloc/preset_bloc.dart';
import 'package:home_app/features/presets/preset/widgets/action_fab/action_fab.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

export 'package:home_app/features/presets/models/preset.dart';

class PresetPage extends StatefulWidget {
  final Preset preset;

  const PresetPage(this.preset, {super.key});

  @override
  State<PresetPage> createState() => _PresetPageState();
}

class _PresetPageState
    extends BlocState<PresetPage, PresetBloc, PresetEvent, PresetState> {
  final _presetActions = <PresetAction>[];

  @override
  PresetEvent? get initialEvent => const RefreshPresetActions();

  @override
  PresetBloc createBloc(KiwiContainer di) {
    return PresetBloc(
      preset: widget.preset,
      dbService: di.resolve<DatabaseService>(),
    );
  }

  @override
  void onStateChange(BuildContext context, PresetState newState) {
    super.onStateChange(context, newState);

    if (newState.hasError) {
      SnackBarPresenter.presentError(
        ScaffoldMessenger.of(context),
        newState.error!,
      );
    } else if (!newState.loading && newState.hasData) {
      setState(() {
        _presetActions.clear();
        _presetActions.addAll(newState.data!);
      });
    }
  }

  @override
  Widget buildState(BuildContext context, PresetState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preset.name),
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            onPressed: state.loading
                ? null
                : () => bloc.add(const RefreshPresetActions()),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              // Add 1 to display the "Add Action" button
              itemCount: _presetActions.length + 1,
              itemBuilder: (_, index) {
                if (index == _presetActions.length) {
                  return Center(
                    child: ElevatedButton.icon(
                      icon: FaIcon(FontAwesomeIcons.plus),
                      label: Text("Add action"),
                      onPressed: () => NavigationService.navigateTo(
                        MyDevicesNavigator(
                          preset: widget.preset,
                          onDeviceSaved: (myDevice, presetAction) =>
                              bloc.add(const RefreshPresetActions()),
                        ),
                      ),
                    ),
                  );
                }
                final presetAction = _presetActions[index];
                return Dismissible(
                  key: Key(presetAction.id.toString()),
                  background: Container(
                    color: Colors.red[700],
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: FaIcon(
                          FontAwesomeIcons.trash,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      bloc.add(RemovePresetAction(presetAction));
                      return Future.value(true);
                    }

                    return Future.value(false);
                  },
                  child: Card(
                    child: ListTile(
                      onTap: null,
                      title: Text(presetAction.device!.name),
                      titleTextStyle: Theme.of(context).textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                      subtitle: Text(
                        "${presetAction.instructionName.name} = ${presetAction.instructionValue}",
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ActionFab(presetActions: state.data),
    );
  }
}
