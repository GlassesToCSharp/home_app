import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/mixins/mock_repository.dart';
import 'package:network_tools/network_tools.dart';

export 'package:connectivity_plus/connectivity_plus.dart';

part 'live_connectivity_service.dart';
part 'mock_connectivity_service.dart';

abstract class ConnectivityService {
  const ConnectivityService();
  Future<bool> isConnectedToLocalNetwork();
  Future<List<Device>> scanForDevices();
}
