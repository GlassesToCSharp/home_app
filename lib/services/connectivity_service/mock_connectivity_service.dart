part of 'connectivity_service.dart';

class MockConnectivityService extends ConnectivityService with MockRepository {
  const MockConnectivityService();

  @override
  Future<bool> isConnectedToLocalNetwork() {
    return returnDelayed(true);
  }

  @override
  Future<List<Device>> scanForDevices() {
    const subnet = "192.168.1";
    return generateData(
      5,
      (count, generator) => Device(
        ipAddress: "$subnet.${generator.nextInt(256)}",
      ),
    );
  }
}
