import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/router.dart';
import 'base.dart';

class StartUpViewModel extends BaseViewModel {
  Future<void> onModelReady() async {
    await Future.delayed(const Duration(seconds: 3));

    if ((await Permission.locationWhenInUse.status).isDenied) {
      debugPrint('is not granted');
      if (!(await Permission.locationWhenInUse.request()).isGranted) {
        await Future.delayed(const Duration(seconds: 1));
        await Permission.locationWhenInUse.request();
      }
    }

    if (FirebaseAuth.instance.currentUser == null) {
      Get.offAndToNamed(AppRoutes.login);
    } else {
      // Get.offAndToNamed(AppRoutes.login);
      String id = FirebaseAuth.instance.currentUser!.uid;
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: id)
          .get();
      if(result.docs.isEmpty){
        Get.offAndToNamed(AppRoutes.login);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', id).whenComplete(() => Get.offAndToNamed(AppRoutes.home));
      }
    }
  }
}
