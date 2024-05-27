import 'package:flutter/material.dart';
import 'package:home_app/features/devices/widgets/router_status_container/bloc/router_status_container_bloc.dart';
import 'package:home_app/models/bloc_state.dart';
import 'package:home_app/services/snackbar_presenter/snackbar_presenter.dart';

class RouterStatusContainer extends StatefulWidget {
  final DevicesBloc devicesBloc;

  const RouterStatusContainer({required this.devicesBloc});

  @override
  State<RouterStatusContainer> createState() => _RouterStatusContainerState();
}

class _RouterStatusContainerState extends BlocState<
    RouterStatusContainer,
    RouterStatusContainerBloc,
    RouterStatusContainerEvent,
    RouterStatusContainerState> {
  @override
  RouterStatusContainerEvent? get initialEvent => const GetRouterInfo();

  @override
  RouterStatusContainerBloc createBloc(KiwiContainer di) {
    return RouterStatusContainerBloc(devicesBloc: widget.devicesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: super.build(context),
    );
  }

  @override
  Widget buildState(BuildContext context, RouterStatusContainerState state) {
    String routerName = "";
    String scanStatus = "";
    String routerIpAddress = "";
    if (state.hasError) {
      SnackBarPresenter.presentError(
          ScaffoldMessenger.of(context), state.error!);
    } else {
      routerName = state.data?.routerName ?? "";
      routerIpAddress = state.data?.ipAddress ?? "";
      scanStatus = state.loading ? "Scanning" : "Scan complete";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("WiFi Connection:"),
            const Expanded(child: SizedBox()),
            Text(routerName),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("IP Address:"),
            const Expanded(child: SizedBox()),
            Text(routerIpAddress),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Status:"),
            const Expanded(child: SizedBox()),
            if (state.loading) ...[
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
            Text(scanStatus),
          ],
        ),
      ],
    );
  }
}
