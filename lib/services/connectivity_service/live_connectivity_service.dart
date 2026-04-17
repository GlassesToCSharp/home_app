part of 'connectivity_service.dart';

class LiveConnectivityService extends ConnectivityService {
  final Connectivity connectivity;

  LiveConnectivityService() : connectivity = Connectivity();

  @override
  Future<bool> isConnectedToLocalNetwork() {
    return connectivity.checkConnectivity().then(
      (result) =>
          result.contains(ConnectivityResult.wifi) ||
          // Potential for web/PC use?
          result.contains(ConnectivityResult.ethernet),
    );
  }

  @override
  Future<List<Device>> scanForDevices() async {
    const int port = 4210; // TODO: make this configurable?
    final devices = <Device>[];

    // Bind to any available port
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    socket.broadcastEnabled = true;

    socket.send(
      utf8.encode("DISCOVER_NODEMCU"),
      InternetAddress("255.255.255.255"),
      port,
    );

    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram != null) {
          devices.add(
            Device(
              ipAddress: datagram.address.address,
              // We don't want a null status, but still don't show this as a
              // valid node device.
              nodeDeviceStatus: NodeDeviceStatus.empty(),
            ),
          );
        }
      }
    });

    // Stop listening after a timeout
    await Future.delayed(Duration(seconds: 5));
    socket.close();

    return devices;
  }
}
