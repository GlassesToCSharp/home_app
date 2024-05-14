import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:home_app/services/injection/dependency_injection.dart';

export 'package:kiwi/kiwi.dart';

abstract class BlocState<T extends StatefulWidget, B extends Bloc<E, S>, E, S>
    extends State<T> with AutomaticKeepAliveClientMixin {
  B? _bloc;

  B get bloc => _bloc ?? _createBloc();

  E? get initialEvent => null;

  @override
  bool get wantKeepAlive => false;

  BlocState() : super();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_bloc == null) {
      _bloc = _createBloc();
      final localInitialEvent = initialEvent;
      if (localInitialEvent != null) {
        bloc.add(localInitialEvent);
      }
    }

    return BlocBuilder<B, S>(
      bloc: _bloc,
      builder: buildState,
    );
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  B createBloc(KiwiContainer di);

  Widget buildState(BuildContext context, S state);

  B _createBloc() {
    return createBloc(DependencyInjectorInheritance.of(context)?.container ??
        KiwiContainer());
  }
}
