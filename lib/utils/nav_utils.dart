import 'package:flutter/material.dart';

String getCurrentRoute(GlobalKey<NavigatorState>? navigatorKey) {
  String currentRoute = '';
  navigatorKey?.currentState?.popUntil((route) {
    currentRoute = route.settings.name ?? '';
    return true;
  });
  return currentRoute;
}
