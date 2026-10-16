import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/presets/models/preset.dart';
import 'package:home_app/features/presets/preset/models/preset_action.dart';
import 'package:home_app/features/presets/widgets/scaffold_preset/widgets/scaffold_preset_actions/bloc/scaffold_preset_actions_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/models/node_device_led_color.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

export 'package:home_app/features/presets/models/preset.dart';

class ScaffoldPresetActions extends StatefulWidget {
  final Preset preset;

  const ScaffoldPresetActions({required this.preset, super.key});

  @override
  State<ScaffoldPresetActions> createState() => _ScaffoldPresetActionsState();
}

class _ScaffoldPresetActionsState
    extends
        BlocState<
          ScaffoldPresetActions,
          ScaffoldPresetActionsBloc,
          ScaffoldPresetActionsEvent,
          ScaffoldPresetActionsState
        > {
  @override
  ScaffoldPresetActionsEvent? get initialEvent =>
      LoadPresetActions(widget.preset);

  @override
  ScaffoldPresetActionsBloc createBloc(KiwiContainer di) {
    return ScaffoldPresetActionsBloc(dbService: di.resolve<DatabaseService>());
  }

  @override
  Widget buildState(BuildContext context, ScaffoldPresetActionsState state) {
    if (state.hasError) {
      return CentralErrorDisplay(
        message: state.error!,
        onRetry: () => bloc.add(initialEvent!),
      );
    } else if (state.loading) {
      return const CentralLoadingIndicator();
    } else {
      return ListView.builder(
        itemCount: state.data!.length,
        itemBuilder: (context, index) {
          final presetAction = state.data![index];
          return ListTile(
            title: Text(presetAction.device?.name ?? "Unknown device"),
            subtitle: Text(presetAction.instructionName.name),
            trailing: _generateWidgetForAction(presetAction),
          );
        },
      );
    }
  }

  Widget _generateWidgetForAction(PresetAction presetAction) {
    final instructionValue = presetAction.instructionValue;
    switch (presetAction.instructionName) {
      case InstructionName.power:
        return FaIcon(
          FontAwesomeIcons.boltLightning,
          color: instructionValue > 0 ? Colors.amber : Colors.grey,
        );

      case InstructionName.neonBrightness:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.solidLightbulb,
              color: Colors.amber.withAlpha(instructionValue),
            ),
          ],
        );

      case InstructionName.ledColor:
        final color = Color(instructionValue);
        final nodeColor = NodeDeviceLedColor(
          red: (color.r * 255).toInt(),
          green: (color.g * 255).toInt(),
          blue: (color.b * 255).toInt(),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(nodeColor.toHexString()),
            const SizedBox(width: 10),
            Container(width: 20, height: 20, color: color),
          ],
        );

      default:
        return FaIcon(FontAwesomeIcons.question);
    }
  }
}
