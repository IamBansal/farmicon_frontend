import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../constants/enums/connectivity_status.dart';

class ConnectivityService {
  ConnectivityService() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        final isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
        if (isDeviceConnected) {
          connectionStatusController?.add(ConnectivityStatus.online);
        } else {
          connectionStatusController?.add(ConnectivityStatus.offline);
        }
      } else {
        connectionStatusController?.add(ConnectivityStatus.offline);
      }
    });
  }

  StreamController<ConnectivityStatus>? connectionStatusController =
      StreamController<ConnectivityStatus>();
}
