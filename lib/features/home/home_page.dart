import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/devices_page.dart';
import 'package:home_app/features/presets/presets_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _maxGridSize = 100.0;

  // Pages should be pre-initialised, so load them in a list.
  final _pages = <Widget>[DevicesPage(onDeviceSelected: (_) {}), PresetsPage()];
  bool _isShowingPresets = true;
  int _selectedPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int gridCrossCount = (screenWidth / _maxGridSize).floor();
    if (gridCrossCount == 0) {
      gridCrossCount = 3;
    }

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Home - ${_isShowingPresets ? "Presets" : "Devices"}",
                    ),
                  ),
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
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PageView(
                      controller: _pageController,
                      children: _pages,
                    ),
                  ),
                  if (_isShowingPresets)
                    Positioned.directional(
                      textDirection: TextDirection.ltr,
                      start: 10.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: _buildNavigationButton(FontAwesomeIcons.microchip),
                    ),
                  if (!_isShowingPresets)
                    Positioned.directional(
                      textDirection: TextDirection.ltr,
                      end: 10.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: _buildNavigationButton(
                        FontAwesomeIcons.houseLaptop,
                      ),
                    ),
                ],
              ),
            ),
            // Expanded(child: _isShowingPresets ? _pages[1] : _pages[0]),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildNavigationButton(FaIconData icon) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isShowingPresets = !_isShowingPresets;
          _selectedPageIndex = _isShowingPresets ? 1 : 0;
          _pageController.jumpToPage(_selectedPageIndex);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).cardTheme.color,
        padding: EdgeInsets.zero, // Removes default padding
        shape: CircleBorder(
          side: BorderSide(color: Theme.of(context).iconTheme.color!, width: 3),
        ), // Optional: makes it circular
      ),
      child: FaIcon(icon, color: Theme.of(context).iconTheme.color),
    );
  }
}
