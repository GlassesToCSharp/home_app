import 'package:equatable/equatable.dart';

class RouterInfo extends Equatable {
  final String routerName;
  final String ipAddress;

  @override
  List<Object?> get props => [routerName, ipAddress];

  const RouterInfo({required this.routerName, required this.ipAddress});
}
