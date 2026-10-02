import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/devices/devices_page.dart';
import 'package:home_app/features/my_devices/my_devices_page.dart';
import 'package:home_app/features/my_devices/widgets/scaffold_device/bloc/scaffold_device_bloc.dart';
import 'package:home_app/features/presets/presets_page.dart';
import 'package:home_app/services/injection/dependency_injection.dart';
import 'package:kiwi/kiwi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _maxGridSize = 100.0;

  // Pages should be pre-initialised, so load them in a list.
  final _pages = <Widget>[MyDevicesPage(), PresetsPage()];
  bool _isShowingPresets = true;
  int _selectedPageIndex = 1;
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

    final injector =
        DependencyInjectorInheritance.of(context)?.container ?? KiwiContainer();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home - ${_isShowingPresets ? "Presets" : "My Devices"}"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(
              FontAwesomeIcons.gear,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: injector.resolve<ScaffoldDeviceBloc>(),
                  ),
                ],
                child: PageView(controller: _pageController, children: _pages),
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
                child: _buildNavigationButton(FontAwesomeIcons.houseLaptop),
              ),
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
