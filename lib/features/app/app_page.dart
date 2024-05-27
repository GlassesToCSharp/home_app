import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_app/features/app/bloc/app_bloc.dart';
import 'package:home_app/models/bloc_state.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends BlocState<AppPage, AppBloc, AppEvent, AppState> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const _navigationItems = [
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.satelliteDish), label: "Devices"),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.folderTree), label: "Presets"),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.gear), label: "Settings"),
  ];
  static const _pages = [
    Text(
      'Index 0: Devices',
      style: optionStyle,
    ),
    Text(
      'Index 1: Presets',
      style: optionStyle,
    ),
    Text(
      'Index 2: Settings',
      style: optionStyle,
    ),
  ];

  int _selectedIndex = 0;

  @override
  AppEvent? get initialEvent => const LoadApp();

  @override
  AppBloc createBloc(KiwiContainer di) {
    return AppBloc(connectivityService: di.resolve<ConnectivityService>());
  }

  @override
  Widget buildState(BuildContext context, AppState state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
        currentIndex: _selectedIndex,
        items: _navigationItems,
      ),
    );
  }

  void _onTap(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
  }
}
