import 'package:equatable/equatable.dart';

abstract class BaseState<T> extends Equatable {
  final bool loading;
  final T? data;
  final String? error;

  @override
  List<Object?> get props => [
        loading,
        data,
        error,
      ];

  List<Object?> get additionalProps => [];

  const BaseState._({
    required this.loading,
    required this.data,
    required this.error,
  });

  const BaseState.loading({T? data})
      : this._(loading: true, data: data, error: null);

  const BaseState.data({required T data})
      : this._(loading: false, data: data, error: null);

  const BaseState.error({required String? error, T? data})
      : this._(loading: false, data: data, error: error);
}
