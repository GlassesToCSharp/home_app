part of 'connectivity_service.dart';

class LiveConnectivityService extends ConnectivityService {
  final Connectivity connectivity;
  final LanScanner scanner;

  LiveConnectivityService()
      : connectivity = Connectivity(),
        scanner = LanScanner();

  @override
  Future<bool> isConnectedToLocalNetwork() {
    return connectivity.checkConnectivity().then((result) =>
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet));
  }

  @override
  Future<List<Device>> scanForDevices(String subnet) async {
    final hosts = await scanner.quickIcmpScanAsync(subnet);
    final devices = <Device>[];
    for (final host in hosts) {
      if (host.internetAddress.type == InternetAddressType.IPv4) {
        devices.add(Device(name: "", ipAddress: host.internetAddress.address));
      }
    }
    return devices;
  }
}
