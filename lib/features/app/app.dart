import 'package:flutter/material.dart';
import 'package:home_app/features/app/app_page.dart';
import 'package:home_app/services/injection/dependency_injection.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DependencyInjection(
        child: AppPage(),
      ),
    );
  }
}
