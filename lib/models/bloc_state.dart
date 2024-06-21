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

      if (initialEvent != null) {
        // A warning is shown saying not to use the null-check operator, rather
        // to do a null-check using `if`. Even if we do a null-check as suggested,
        // the warning stays. Therefore, ignore it.
        //ignore: null_check_on_nullable_type_parameter
        bloc.add(initialEvent!);
      }
    }

    return BlocListener<B, S>(
      listener: onStateChange,
      bloc: _bloc,
      child: BlocBuilder<B, S>(
        bloc: _bloc,
        builder: buildState,
      ),
    );
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  B createBloc(KiwiContainer di);

  void onStateChange(context, S newState) {}

  Widget buildState(BuildContext context, S state);

  B _createBloc() {
    return createBloc(DependencyInjectorInheritance.of(context)?.container ??
        KiwiContainer());
  }
}
