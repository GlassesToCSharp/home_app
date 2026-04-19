import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/presets/bloc/presets_bloc.dart';
import 'package:home_app/features/presets/preset/preset_navigator.dart';
import 'package:home_app/features/presets/widgets/name_entry_dialog.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage();

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState
    extends BlocState<PresetsPage, PresetsBloc, PresetsEvent, PresetsState> {
  final _presets = <Preset>[];

  @override
  PresetsEvent? get initialEvent => const GetPresets();

  @override
  PresetsBloc createBloc(KiwiContainer di) {
    return PresetsBloc(dbService: di.resolve<DatabaseService>());
  }

  @override
  void onStateChange(BuildContext context, PresetsState newState) {
    super.onStateChange(context, newState);

    if (newState.hasData) {
      setState(() {
        _presets.clear();
        _presets.addAll(newState.data!);
      });
    }
  }

  @override
  Widget buildState(BuildContext context, PresetsState state) {
    Widget body = const SizedBox();
    if (state.hasError) {
      body = CentralErrorDisplay(message: state.error!, onRetry: _getPresets);
    } else if (state.loading) {
      body = const CentralLoadingIndicator();
    } else if (_presets.isEmpty) {
      body = CentralErrorDisplay(
        message: "No presets saved",
        onRetry: _getPresets,
      );
    } else {
      body = ListView.builder(
        itemCount: _presets.length,
        itemBuilder: (_, index) {
          if (index >= _presets.length) {
            return const SizedBox();
          }
          final preset = _presets[index];
          return Dismissible(
            key: Key(_presets[index].id.toString()),
            background: Container(
              color: Colors.red[700],
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: FaIcon(FontAwesomeIcons.trash, color: Colors.white),
                ),
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              if (direction == DismissDirection.endToStart) {
                bloc.add(RemovePreset(preset));
                return Future.value(true);
              }

              return Future.value(false);
            },
            child: Card(
              child: ListTile(
                onTap: () =>
                    NavigationService.navigateTo(PresetNavigator(preset)),
                title: Text(preset.name),
                titleTextStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Presets"),
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            onPressed: state.loading ? null : _getPresets,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: body)],
      ),
      floatingActionButton: state.loading
          ? null
          : FloatingActionButton(
              onPressed: state.loading
                  ? null
                  : () async {
                      await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return NameEntryDialog(
                            onSubmit: (name) => bloc.add(CreatePreset(name)),
                          );
                        },
                      );
                    },
              child: FaIcon(FontAwesomeIcons.plus),
              //  state.loading
              //     ? null
              //     : () => bloc.add(
              //         Execute(_presetActions[_selectedIndex].newValues),
              //       ),
            ),
    );
  }

  void _getPresets() {
    bloc.add(const GetPresets());
  }
}
