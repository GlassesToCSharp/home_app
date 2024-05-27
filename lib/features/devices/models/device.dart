import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String name;
  final String ipAddress;

  @override
  List<Object?> get props => [name, ipAddress];

  const Device({required this.name, required this.ipAddress});
}
