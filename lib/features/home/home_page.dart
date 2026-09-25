import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _maxGridSize = 100.0;
  final _testData = List.generate(100, (i) => i);
  bool _isShowingPresets = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int gridCrossCount = (screenWidth / _maxGridSize).floor();
    if (gridCrossCount == 0) {
      gridCrossCount = 3;
    }
    debugPrint("Cross Count: $gridCrossCount");

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
              // Padding(
              //   padding: const EdgeInsetsGeometry.all(20),
              //   child: Container(
              //     width: _maxGridSize,
              //     constraints: BoxConstraints(maxWidth: _maxGridSize),
              //     height: _maxGridSize,
              //     color: Colors.red,
              //   ),
              // ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: gridCrossCount,
                  children: _testData
                      .map(
                        (index) => SizedBox(
                          height: _maxGridSize.toDouble(),
                          width: _maxGridSize.toDouble(),
                          child: Card(
                            child: InkWell(
                              onTap: () {},
                              // TODO: Fix the corner radius
                              child: Center(
                                child: Text(
                                  "${_isShowingPresets ? "Preset" : "Device"} $index",
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
