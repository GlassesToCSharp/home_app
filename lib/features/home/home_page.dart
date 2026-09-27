import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/devices_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _maxGridSize = 100.0;
  bool _isShowingPresets = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int gridCrossCount = (screenWidth / _maxGridSize).floor();
    if (gridCrossCount == 0) {
      gridCrossCount = 3;
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text("Home")),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isShowingPresets = !_isShowingPresets;
                      });
                    },
                    icon: FaIcon(
                      _isShowingPresets
                          ? FontAwesomeIcons.list
                          : FontAwesomeIcons.ellipsisVertical,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.gear),
                  ),
                ],
              ),
              Expanded(child: DevicesPage(onDeviceSelected: (d) {})),
            ],
          ),
        ),
      ),
    );
  }
}
