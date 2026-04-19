import 'package:flutter/material.dart';
import 'package:home_app/features/presets/models/preset.dart';

class PresetPage extends StatefulWidget {
  const PresetPage({super.key});

  @override
  State<PresetPage> createState() => _PresetPageState();
}

class _PresetPageState extends State<PresetPage> {
  final _presetActions = <Preset>[];

  @override
  Widget build(BuildContext context) {
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
              itemCount: _presetActions.length,
              itemBuilder: (_, index) {
                if (index >= _presetActions.length) {
                  return const SizedBox();
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
