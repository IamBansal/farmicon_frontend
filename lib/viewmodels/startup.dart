import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/router.dart';
import 'base.dart';

class StartUpViewModel extends BaseViewModel {
  //Initializers:
  Future<void> onModelReady() async {
    //Wait for three seconds.
    await Future.delayed(const Duration(seconds: 3));

    // Check for permissions.
    if ((await Permission.locationWhenInUse.status).isDenied) {
      debugPrint('is not granted');
      if (!(await Permission.locationWhenInUse.request()).isGranted) {
        // Get.snackbar(
        //   S.current.locationPermission,
        //   S.current.locationPermissionRequest,
        // );

        await Future.delayed(const Duration(seconds: 1));

        await Permission.locationWhenInUse.request();
      }
    }

    if (FirebaseAuth.instance.currentUser == null) {
      Get.offAndToNamed(AppRoutes.login);
    } else {
      Get.offAndToNamed(AppRoutes.home);
    }
  }
}
