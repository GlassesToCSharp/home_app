import 'package:flutter/material.dart';
import 'package:home_app/services/connectivity_service/connectivity_service.dart';
import 'package:home_app/services/storage_service/storage_service.dart';
import 'package:kiwi/kiwi.dart';

const bool _useMock = true;

class DependencyInjection extends StatelessWidget {
  final Widget child;

  KiwiContainer get _container => KiwiContainer();

  const DependencyInjection({required this.child});

  @override
  Widget build(BuildContext context) {
    // try {
    //   container.registerInstance<DownloadFileRepository>(_useMock
    //       ? MockDownloadFileRepository(mockDelay: _mockDelay)
    //       : LiveDownloadFileRepository());
    // } catch (e) {
    //   debugPrint(e.toString());
    // }

    _addInstance<ConnectivityService>(const MockConnectivityService(),
        LiveConnectivityService(Connectivity()));
    _addInstance<StorageService>(LocalStorage(), SafeStorage());

    return DependencyInjectorInheritance(
      container: _container,
      child: child,
    );
  }

  void _addInstance<T>(T mock, T live) {
    try {
      _container.registerInstance<T>(_useMock ? mock : live);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class DependencyInjectorInheritance extends InheritedWidget {
  final KiwiContainer container;

  const DependencyInjectorInheritance(
      {required this.container, required Widget child})
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
