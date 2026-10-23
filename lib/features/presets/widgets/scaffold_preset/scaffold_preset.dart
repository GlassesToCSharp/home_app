import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/presets/preset/preset_navigator.dart';
import 'package:home_app/features/presets/widgets/scaffold_preset/bloc/scaffold_preset_bloc.dart';
import 'package:home_app/features/presets/widgets/scaffold_preset/widgets/preset_named_tile/preset_name_tile_dialog.dart';
import 'package:home_app/features/presets/widgets/scaffold_preset/widgets/scaffold_preset_actions/scaffold_preset_actions.dart.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/dialogs/quick_dialogs.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';
import 'package:home_app/widgets/scaffold_header_tile/scaffold_header_tile.dart';

class ScaffoldPreset extends StatefulWidget {
  final Preset preset;
  final VoidCallback onRemovePreset;

  const ScaffoldPreset({
    required this.preset,
    required this.onRemovePreset,
    super.key,
  });

  @override
  State<ScaffoldPreset> createState() => _ScaffoldPresetState();
}

class _ScaffoldPresetState
    extends
        BlocState<
          ScaffoldPreset,
          ScaffoldPresetBloc,
          ScaffoldPresetEvent,
          ScaffoldPresetState
        > {
  @override
  bool get closeBlocOnDispose => false;

  @override
  ScaffoldPresetEvent? get initialEvent => LoadPreset(widget.preset);

  @override
  ScaffoldPresetBloc createBloc(KiwiContainer di) {
    return context.read<ScaffoldPresetBloc>();
  }

  @override
  Widget buildState(BuildContext context, ScaffoldPresetState state) {
    if (state.hasError) {
      return CentralErrorDisplay(
        message: state.error!,
        onRetry: () => bloc.add(LoadPreset(widget.preset)),
      );
    } else if (state.loading && state.data == null) {
      return CentralLoadingIndicator();
    } else {
      return Column(
        children: [
          // Preset name
          ScaffoldHeaderTile(
            title: state.data!.name,
            edittingDialog: (_) => PresetNameTileDialog(preset: state.data!),
            onSuccess: () => bloc.add(initialEvent!),
          ),

          Divider(),

          // TODO: Set the icon
          ListTile(
            title: Text("Icon"),
            trailing: FaIcon(FontAwesomeIcons.circleExclamation),
          ),
          Expanded(child: ScaffoldPresetActions(preset: state.data!)),
          // ListTile(
          //   title: Text("Actions"),
          //   trailing: FaIcon(FontAwesomeIcons.arrowRight),
          //   onTap: () {
          //     NavigationService.navigateTo(PresetNavigator(state.data!));
          //   },
          // ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () async {
                  NavigationService.navigateTo(PresetNavigator(state.data!));
                },
                label: Text("Edit"),
                icon: FaIcon(FontAwesomeIcons.pencil),
              ),
              TextButton.icon(
                onPressed: () async {
                  final remove = await QuickDialogs.confirmationDialogAsync(
                    context,
                    title: "Remove device?",
                    message: "Remove the device from your device list?",
                    positiveButtonText: "Yes",
                    negativeButtonText: "No",
                  );
                  if (remove == true && state.data != null) {
                    bloc.add(RemovePreset(state.data!));
                    await bloc.stream.firstWhere((s) => !s.loading);
                    NavigationService.pop();
                    widget.onRemovePreset();
                  }
                },
                label: Text("Remove"),
                icon: FaIcon(FontAwesomeIcons.trash),
              ),
            ],
          ),
        ],
      );
    }
  }
}
