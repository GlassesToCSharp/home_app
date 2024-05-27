part of 'connectivity_service.dart';

class LiveConnectivityService extends ConnectivityService {
  final Connectivity connectivity;

  const LiveConnectivityService(this.connectivity);

  @override
  Future<bool> isConnectedToLocalNetwork() {
    return connectivity.checkConnectivity().then((result) =>
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet));
  }
}
