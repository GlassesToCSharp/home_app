import 'package:flutter/material.dart';
import 'package:home_app/services/navigation_service/base_navigator.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<T?> navigateTo<T>(BaseNavigator navigator) {
    return navigatorKey.currentState!.pushNamed<T>("", arguments: navigator);
  }

  static void pop() {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final page = settings.arguments as BaseNavigator;
    return MaterialPageRoute(builder: (_) => page.build());
  }
}
