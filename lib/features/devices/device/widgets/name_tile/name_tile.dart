import 'package:flutter/material.dart';
import 'package:home_app/features/devices/device/widgets/name_tile/name_tile_dialog/name_tile_dialog.dart';
import 'package:home_app/features/devices/models/device.dart';

class NameTile extends StatefulWidget {
  final Device device;

  const NameTile({required this.device});

  @override
  State<NameTile> createState() => _NameTileState();
}

class _NameTileState extends State<NameTile> {
  String _name = "";

  @override
  void initState() {
    super.initState();

    _name = widget.device.name;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Name"),
      trailing: Text(_name),
      onTap: () async {
        final newName = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return NameTileDialog(
              deviceName: _name,
              deviceIpAddress: widget.device.ipAddress,
            );
          },
        );
        if (newName != null && newName != _name) {
          setState(() {
            _name = newName;
          });
        }
      },
    );
  }
}
