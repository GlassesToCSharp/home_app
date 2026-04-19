import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/presets/bloc/presets_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage();

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState
    extends BlocState<PresetsPage, PresetsBloc, PresetsEvent, PresetsState> {
  int _selectedIndex = -1;

  @override
  PresetsEvent? get initialEvent => const GetPresets();

  @override
  PresetsBloc createBloc(KiwiContainer di) {
    return PresetsBloc(dbService: di.resolve<DatabaseService>());
  }

  @override
  Widget buildState(BuildContext context, PresetsState state) {
    Widget body = const SizedBox();
    if (state.hasError) {
      body = CentralErrorDisplay(message: state.error!, onRetry: _getPresets);
    } else if (state.loading) {
      body = const CentralLoadingIndicator();
    } else if (!state.hasData || state.data!.isEmpty) {
      body = CentralErrorDisplay(
        message: "No presets saved",
        onRetry: _getPresets,
      );
    } else {
      final presets = state.data!;
      body = ListView.builder(
        itemCount: presets.length,
        itemBuilder: (_, index) {
          if (index >= presets.length) {
            return const SizedBox();
          }
          final presetAction = presets[index];
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
              titleTextStyle: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              selected: _selectedIndex == index,
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: body)],
      ),
      floatingActionButton: state.loading
          ? null
          : FloatingActionButton(
              onPressed: null,
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
