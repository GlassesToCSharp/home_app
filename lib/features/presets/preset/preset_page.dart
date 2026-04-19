import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/presets/models/preset.dart';

export 'package:home_app/features/presets/models/preset.dart';

class PresetPage extends StatefulWidget {
  final Preset preset;

  const PresetPage(this.preset, {super.key});

  @override
  State<PresetPage> createState() => _PresetPageState();
}

class _PresetPageState extends State<PresetPage> {
  final _presetActions = <Preset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preset.name),
        backgroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 8,
        shadowColor: Colors.grey,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.pen),
            onPressed: null, // TODO: Edit name of preset
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
                      onPressed: () {},
                    ),
                  );
                }
                final presetAction = _presetActions[index];
                return Card(
                  child: ListTile(
                    onTap: null,
                    title: Text(presetAction.name),
                    titleTextStyle: Theme.of(context).textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        label: const Text("Action"),
      ),
    );
  }
}
