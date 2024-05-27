import 'package:connectivity_plus/connectivity_plus.dart';

export 'package:connectivity_plus/connectivity_plus.dart';

part 'live_connectivity_service.dart';
part 'mock_connectivity_service.dart';

abstract class ConnectivityService {
  const ConnectivityService();
  Future<bool> isConnectedToLocalNetwork();
}
