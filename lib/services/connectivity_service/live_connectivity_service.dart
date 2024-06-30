part of 'connectivity_service.dart';

class LiveConnectivityService extends ConnectivityService {
  final Connectivity connectivity;
  final MdnsScannerService scanner;

  LiveConnectivityService()
      : connectivity = Connectivity(),
        scanner = MdnsScannerService.instance;

  @override
  Future<bool> isConnectedToLocalNetwork() {
    return connectivity.checkConnectivity().then((result) =>
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet));
  }

  @override
  Future<List<Device>> scanForDevices() async {
    final mdnsDevices = await scanner.searchMdnsDevices();
    final devices = <Device>[];
    for (final mdnsDevice in mdnsDevices) {
      final mdnsInfo = await mdnsDevice.mdnsInfo;
      if (mdnsInfo == null) {
        continue;
      }
      final mdnsName = mdnsInfo.getOnlyTheStartOfMdnsName();
      // The devices we want will have a predefined name to filter by.
      if (mdnsName == "LocalNodeMCU4IoT") {
        devices.add(Device(ipAddress: "${mdnsDevice.address}:80"));
      }
    }

    return devices;
  }
}
