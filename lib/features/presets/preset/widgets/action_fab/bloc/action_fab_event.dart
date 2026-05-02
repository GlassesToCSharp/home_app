part of 'action_fab_bloc.dart';

abstract class ActionFabEvent extends Equatable {
  const ActionFabEvent();

  @override
  List<Object> get props => [];
}

class ExecuteActions extends ActionFabEvent {
  const ExecuteActions();
}
