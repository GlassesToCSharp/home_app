part of 'connectivity_service.dart';

class MockConnectivityService extends ConnectivityService with MockRepository {
  const MockConnectivityService();

  @override
  Future<bool> isConnectedToLocalNetwork() {
    return returnDelayed(true);
  }

  @override
  Future<List<Device>> scanForDevices(String subnet) {
    return generateData(
      5,
      (count, generator) => Device(
        ipAddress: "$subnet.${generator.nextInt(256)}",
      ),
    );
  }
}
