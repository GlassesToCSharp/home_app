// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:home_app/features/devices/device/device_navigator.dart';
// import 'package:home_app/features/my_devices/widgets/device_item/bloc/device_item_bloc.dart';
// import 'package:home_app/models/bloc_state.dart';
// import 'package:home_app/services/navigation_service/navigation_service.dart';

// export 'package:home_app/features/my_devices/models/my_device.dart';

// class DeviceItem extends StatefulWidget {
//   final Device device;
//   final bool requestRefreshStatus;
//   final Function(MyDevice)? onSave;

//   const DeviceItem({
//     required this.device,
//     this.requestRefreshStatus = false,
//     this.onSave,
//     super.key,
//   });

//   @override
//   State<DeviceItem> createState() => _DeviceItemState();
// }

// class _DeviceItemState
//     extends
//         BlocState<
//           DeviceItem,
//           DeviceItemBloc,
//           DeviceItemEvent,
//           DeviceItemState
//         > {
//   static const _iconSize = 16.0;

//   Device get device => widget.device;

//   @override
//   DeviceItemEvent? get initialEvent => widget.requestRefreshStatus
//       ? const GetDeviceData()
//       : SetDeviceData(device);

//   @override
//   DeviceItemBloc createBloc(KiwiContainer di) {
//     return DeviceItemBloc(
//       device: device,
//       repository: di.resolve<NodeDeviceRepository>(),
//       dbService: di.resolve<DatabaseService>(),
//     );
//   }

//   @override
//   Widget buildState(BuildContext context, DeviceItemState state) {
//     return Card(
//       child: Stack(
//         children: [
//           ListTile(
//             onTap: (state.loading || state.hasError)
//                 ? null
//                 : () {
//                     NavigationService.navigateTo(
//                       DeviceNavigator(device: state.data!),
//                     );
//                   },
//             title: Text(
//               state.data?.name == null ? device.name : state.data!.name,
//             ),
//             titleTextStyle: Theme.of(
//               context,
//             ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
//             subtitle: Text(device.ipAddress),
//             // Show what features are available for each device
//             trailing: state.data == null
//                 ? null
//                 : state.data!.isNodeDevice
//                 ? Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (state.data!.nodeDeviceStatus.hasPowerState)
//                             const FaIcon(
//                               FontAwesomeIcons.boltLightning,
//                               color: Colors.amber,
//                               size: _iconSize,
//                             ),
//                           if (state
//                               .data!
//                               .nodeDeviceStatus
//                               .hasNeonBrightnessState)
//                             const FaIcon(
//                               FontAwesomeIcons.solidLightbulb,
//                               color: Colors.amber,
//                               size: _iconSize,
//                             ),
//                         ],
//                       ),
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (state.data!.nodeDeviceStatus.hasLedColorState)
//                             const FaIcon(
//                               FontAwesomeIcons.palette,
//                               color: Colors.red,
//                               size: _iconSize,
//                             ),
//                           if (state.data!.nodeDeviceStatus.hasMotorState)
//                             const FaIcon(
//                               FontAwesomeIcons.gear,
//                               color: Colors.blueGrey,
//                               size: _iconSize,
//                             ),
//                         ],
//                       ),
//                     ],
//                   )
//                 : null,
//           ),
//           // isNodeDevice will tell us if the device has been reached.
//           if (state.loading || !device.isNodeDevice || state.hasError)
//             // Show a warning message of the list tile
//             Positioned.fill(
//               child: Container(
//                 color: Colors.blueGrey.withAlpha(200),
//                 child: Center(
//                   child: Text(
//                     state.loading
//                         ? "Fetching device data..."
//                         : state.hasError
//                         ? state.error!
//                         : !device.isNodeDevice
//                         ? "Device not available"
//                         : "Unknown issue",
//                     style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
