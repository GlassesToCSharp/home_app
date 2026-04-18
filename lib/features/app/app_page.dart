import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/app/bloc/app_bloc.dart';
import 'package:home_app/features/devices/devices_page.dart';
import 'package:home_app/features/my_devices/my_devices_page.dart';
import 'package:home_app/features/presets/presets_page.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/widgets/central_error_display.dart';
import 'package:home_app/widgets/central_loading_indicator.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends BlocState<AppPage, AppBloc, AppEvent, AppState> {
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static final _navigationItems = [
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.satelliteDish),
      label: "My Devices",
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.folderTree),
      label: "Presets",
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.gear),
      label: "Settings",
    ),
  ];
  static const _pages = [
    MyDevicesPage(),
    PresetsPage(devices: {}),
    Center(child: Text('Index 2: Settings', style: optionStyle)),
  ];

  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  AppEvent? get initialEvent => const LoadApp();

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  AppBloc createBloc(KiwiContainer di) {
    return AppBloc(connectivityService: di.resolve<ConnectivityService>());
  }

  @override
  Widget buildState(BuildContext context, AppState state) {
    if (state.hasError) {
      return CentralErrorDisplay(
        message: state.error!,
        onRetry: () => bloc.add(const LoadApp()),
      );
    }

    if (state.loading) {
      return const CentralLoadingIndicator();
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
        currentIndex: _selectedIndex,
        items: _navigationItems,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
      _pageController.jumpToPage(_selectedIndex);
    });
  }
}
