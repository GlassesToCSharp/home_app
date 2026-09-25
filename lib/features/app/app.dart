import 'package:flutter/material.dart';
import 'package:home_app/features/app/app_page.dart';
import 'package:home_app/services/injection/dependency_injection.dart';
import 'package:home_app/services/navigation_service/navigation_service.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      textTheme: TextTheme(bodySmall: TextStyle(color: Colors.black)),
    );
    final _darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.amber,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.amber,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
      ),
      cardTheme: CardThemeData(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blueGrey, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.blueGrey),
      textTheme: TextTheme(bodySmall: TextStyle(color: Colors.white)),
    );
    return MaterialApp(
      title: 'Home App',
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // ThemeData(
      //   colorScheme: ColorScheme.fromSwatch(),
      //   progressIndicatorTheme: Theme.of(context).progressIndicatorTheme,
      //   elevatedButtonTheme: Theme.of(context).elevatedButtonTheme,
      //   scaffoldBackgroundColor: Colors.grey[100],
      //   bottomNavigationBarTheme: Theme.of(
      //     context,
      //   ).bottomNavigationBarTheme.copyWith(backgroundColor: Colors.grey[300]),
      // ),
      home: const DependencyInjection(child: AppPage()),
    );
  }
}
