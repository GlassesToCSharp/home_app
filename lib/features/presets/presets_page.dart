import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/widgets/device_item/device_item.dart';
import 'package:home_app/features/presets/bloc/presets_bloc.dart';
import 'package:home_app/features/presets/preset/preset_navigator.dart';
import 'package:home_app/features/presets/widgets/name_entry_dialog.dart';
import 'package:home_app/features/presets/widgets/preset_item/preset_item.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage();

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState
    extends BlocState<PresetsPage, PresetsBloc, PresetsEvent, PresetsState> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final _presets = <Preset>[];

  @override
  bool get wantKeepAlive => true;

  @override
  PresetsEvent? get initialEvent => const GetPresets();

  @override
  PresetsBloc createBloc(KiwiContainer di) {
    return PresetsBloc(dbService: di.resolve<DatabaseService>());
  }

  @override
  void onStateChange(BuildContext context, PresetsState newState) {
    super.onStateChange(context, newState);

    if (newState.hasError) {
      SnackBarPresenter.presentError(
        ScaffoldMessenger.of(context),
        newState.error!,
      );
    } else if (!newState.loading && newState.hasData) {
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
    } else if (state.loading && (!state.hasData || state.data!.isEmpty)) {
      body = const CentralLoadingIndicator();
    } else {
      final devices = state.data!;
      final screenWidth = MediaQuery.of(context).size.width;
      int gridCrossCount = (screenWidth / DeviceItem.maxItemSize).floor();
      if (gridCrossCount == 0) {
        gridCrossCount = 3;
      }

      body = RefreshIndicator.adaptive(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          _getPresets();
          await bloc.stream.firstWhere((s) => !s.loading);
        },
        child: GridView.count(
          crossAxisCount: gridCrossCount,
          childAspectRatio: 2,
          children: [
            ..._mapPresetsToWidgets(devices),
            SizedBox(
              height: DeviceItem.maxItemSize,
              width: DeviceItem.maxItemSize,
              child: Card(
                child: InkWell(
                  onTap: () async {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return NameEntryDialog(
                          onSubmit: (name) => bloc.add(CreatePreset(name)),
                        );
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsetsGeometry.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Add device"),
                        Expanded(
                          child: Center(
                            child: FaIcon(FontAwesomeIcons.circlePlus),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      // body = ListView.builder(
      //   itemCount: _presets.length,
      //   itemBuilder: (_, index) {
      //     if (index >= _presets.length) {
      //       return const SizedBox();
      //     }
      //     final preset = _presets[index];
      //     return Dismissible(
      //       key: Key(_presets[index].id.toString()),
      //       background: Container(
      //         color: Colors.red[700],
      //         child: const Align(
      //           alignment: Alignment.centerRight,
      //           child: Padding(
      //             padding: EdgeInsets.only(right: 16),
      //             child: FaIcon(FontAwesomeIcons.trash, color: Colors.white),
      //           ),
      //         ),
      //       ),
      //       direction: DismissDirection.endToStart,
      //       confirmDismiss: (direction) {
      //         if (direction == DismissDirection.endToStart) {
      //           bloc.add(RemovePreset(preset));
      //           return Future.value(true);
      //         }

      //         return Future.value(false);
      //       },
      //       child: Card(
      //         child: ListTile(
      //           onTap: () =>
      //               NavigationService.navigateTo(PresetNavigator(preset)),
      //           title: Text(preset.name),
      //           titleTextStyle: Theme.of(
      //             context,
      //           ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
      //           trailing: IconButton(
      //             icon: const FaIcon(FontAwesomeIcons.pen, size: 16),
      //             onPressed: () async {
      //               await showDialog<String>(
      //                 context: context,
      //                 builder: (BuildContext context) {
      //                   return NameEntryDialog(
      //                     initialName: preset.name,
      //                     onSubmit: (newName) => bloc.add(
      //                       UpdatePreset(Preset(id: preset.id, name: newName)),
      //                     ),
      //                   );
      //                 },
      //               );
      //             },
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // );

      // if (state.hasData && state.data!.isNotEmpty) {
      //   body = RefreshIndicator(
      //     onRefresh: () {
      //       _getPresets();
      //       return bloc.stream.firstWhere((s) => !s.loading);
      //     },
      //     child: body,
      //   );
      // }
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: body)],
      ),
    );
  }

  void _getPresets() {
    bloc.add(const GetPresets());
  }

  List<Widget> _mapPresetsToWidgets(List<Preset> presets) {
    return presets.map((preset) {
      return PresetItem(
        preset: preset,
        onTap: (preset) =>
            NavigationService.navigateTo(PresetNavigator(preset)),
      );
    }).toList();
  }
}
