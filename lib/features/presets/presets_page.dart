import 'package:flutter/material.dart';
import 'package:home_app/features/presets/bloc/presets_bloc.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/models/bloc_state.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage();

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState
    extends BlocState<PresetsPage, PresetsBloc, PresetsEvent, PresetsState> {
  int _selectedIndex = -1;

  final _presets = <Preset>[
    Preset(id: 1, name: "Open Trinity"),
    Preset(id: 2, name: "Close Trinity"),
  ];

  @override
  PresetsBloc createBloc(KiwiContainer di) {
    return PresetsBloc(dbService: di.resolve<DatabaseService>());
  }

  @override
  Widget buildState(BuildContext context, PresetsState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preset Actions"),
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _presets.length,
              itemBuilder: (_, index) {
                if (index >= _presets.length) {
                  return const SizedBox();
                }
                final presetAction = _presets[index];
                return Card(
                  child: ListTile(
                    onTap: [].isEmpty || state.loading
                        ? null
                        : () {
                            setState(() {
                              if (_selectedIndex == index) {
                                _selectedIndex = -1;
                              } else {
                                _selectedIndex = index;
                              }
                            });
                          },
                    title: Text(presetAction.name),
                    titleTextStyle: Theme.of(context).textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    selected: _selectedIndex == index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex >= 0
          ? FloatingActionButton.extended(
              onPressed: null,
              //  state.loading
              //     ? null
              //     : () => bloc.add(
              //         Execute(_presetActions[_selectedIndex].newValues),
              //       ),
              label: state.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Action"),
            )
          : null,
    );
  }
}
