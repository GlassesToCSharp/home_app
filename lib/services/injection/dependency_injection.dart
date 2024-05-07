import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

const bool _useMock = true;

class DependencyInjection extends StatelessWidget {
  final Widget child;

  const DependencyInjection({required this.child});

  @override
  Widget build(BuildContext context) {
    final container = KiwiContainer();

    // try {
    //   container.registerInstance<DownloadFileRepository>(_useMock
    //       ? MockDownloadFileRepository(mockDelay: _mockDelay)
    //       : LiveDownloadFileRepository());
    // } catch (e) {
    //   debugPrint(e.toString());
    // }

    return DependencyInjectorInheritance(
      container: container,
      child: child,
    );
  }
}

class DependencyInjectorInheritance extends InheritedWidget {
  final KiwiContainer container;
  final Widget child;

  DependencyInjectorInheritance({required this.container, required this.child})
      : super(child: child);

  static DependencyInjectorInheritance? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DependencyInjectorInheritance>();
  }

  @override
  bool updateShouldNotify(DependencyInjectorInheritance oldWidget) {
    return true;
  }
}
