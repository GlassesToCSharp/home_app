import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:home_app/features/devices/models/device.dart';
import 'package:home_app/mixins/mock_repository.dart';
import 'package:lan_scanner/lan_scanner.dart';

export 'package:connectivity_plus/connectivity_plus.dart';

part 'live_connectivity_service.dart';
part 'mock_connectivity_service.dart';

abstract class ConnectivityService {
  const ConnectivityService();
  Future<bool> isConnectedToLocalNetwork();
  Future<List<Device>> scanForDevices(String subnet);
}
