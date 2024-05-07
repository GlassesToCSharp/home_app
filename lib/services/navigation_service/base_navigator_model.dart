import 'package:flutter/material.dart';

abstract class BaseNavigatorModel {
  const BaseNavigatorModel();

  String getRouteName();
  Widget build();
}
