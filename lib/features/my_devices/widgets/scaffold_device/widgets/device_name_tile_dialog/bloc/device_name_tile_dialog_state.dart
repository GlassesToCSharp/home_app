part of 'device_name_tile_dialog_bloc.dart';

class DeviceNameTileDialogState extends BaseState<bool> {
  const DeviceNameTileDialogState.loading({bool? data})
    : super.loading(data: data);
  const DeviceNameTileDialogState.data(bool data) : super.data(data: data);
  const DeviceNameTileDialogState.error(String error, {bool? data})
    : super.error(error: error, data: data);
}
