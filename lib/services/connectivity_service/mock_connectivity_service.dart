part of 'connectivity_service.dart';

class MockConnectivityService extends ConnectivityService {
  const MockConnectivityService();

  @override
  Future<bool> isConnectedToLocalNetwork() {
    return Future.value(true);
  }
}
