import 'package:flutter/material.dart';

abstract class BaseNavigator {
  const BaseNavigator();

  String getRouteName();
  Widget build();
}
