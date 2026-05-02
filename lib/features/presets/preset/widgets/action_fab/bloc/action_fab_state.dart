part of 'action_fab_bloc.dart';

class ActionFabState extends BaseState<bool> {
  const ActionFabState.loading({bool? data}) : super.loading(data: data);
  const ActionFabState.data(bool data) : super.data(data: data);
  const ActionFabState.error(String error, {bool? data})
    : super.error(error: error, data: data);
}
