import 'package:flutter/material.dart';
import 'package:home_app/features/app/app_page.dart';
import 'package:home_app/services/injection/dependency_injection.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home App',
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(),
        progressIndicatorTheme: Theme.of(context).progressIndicatorTheme,
        elevatedButtonTheme: Theme.of(context).elevatedButtonTheme,
        scaffoldBackgroundColor: Colors.grey[100],
        bottomNavigationBarTheme: Theme.of(context)
            .bottomNavigationBarTheme
            .copyWith(backgroundColor: Colors.grey[300]),
      ),
      home: const DependencyInjection(
        child: AppPage(),
      ),
    );
  }
}
