part of 'connectivity_service.dart';

class MockConnectivityService extends ConnectivityService with MockRepository {
  final _devices = <Device>[];

  MockConnectivityService();

  @override
  Future<bool> isConnectedToLocalNetwork() {
    return returnDelayed(true);
  }

  @override
  Future<List<Device>> scanForDevices() async {
    const subnet = "192.168.1";
    if (_devices.isEmpty) {
      _devices.addAll(
        await generateData(
          5,
          (count, generator) => Device(
            ipAddress: "$subnet.${generator.nextInt(256)}",
            nodeDeviceStatus: NodeDeviceStatus.empty(),
          ),
        ),
      );
    }
    return _devices;
  }
}
