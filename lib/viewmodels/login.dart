import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/router.dart';
import '../services/app_localizations.dart';
import '../services/location.dart';
import 'base.dart';

class LoginViewModel extends BaseViewModel {
  // Controllers
  late PhoneNumber _phoneNumber;

  // Getters
  PhoneNumber get phoneNumber => _phoneNumber;

  // Setters
  set phoneNumber(PhoneNumber newState) {
    _phoneNumber = newState;
    notifyListeners();
  }

  void setCountry(Country newCountry) {
    _phoneNumber.countryCode = '+${newCountry.dialCode}';
    _phoneNumber.countryISOCode = newCountry.code;
    notifyListeners();
  }

  // Initializer
  void onModelReady() {
    _phoneNumber = PhoneNumber(
      countryISOCode: 'IN',
      countryCode: '+91',
      number: '',
    );
  }

  // Misc
  void sendOtp() {
    Get.toNamed(AppRoutes.otpVerify, arguments: _phoneNumber);
  }

  void googleSignIn() async {
    final googleUser = await GoogleSignIn().signIn();

    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);
      String id = FirebaseAuth.instance.currentUser!.uid;
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();

      if (result.docs.isEmpty) {
        final address = await LocationService.fetchAddress('en');

        await FirebaseFirestore.instance
            .collection('users')
            .add({
              'address': {
                'district': address?['district'] ?? '',
                'city': address?['city'] ?? '',
                'pincode': int.tryParse(address?['postcode']) ?? 0,
                'street_name': address?['street'] ?? '',
              },
          'uid': id,
              'crops-en': [],
              'crops-hi': [],
              'email': FirebaseAuth.instance.currentUser!.email,
              'name': FirebaseAuth.instance.currentUser!.displayName,
              'phone_number': null
            })
            .then((value) => debugPrint('DB USER CREATED'))
            .catchError((error) => debugPrint('db user creation failed'));
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', id);
      Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('successSignIn').toString());
      Get.offAllNamed(AppRoutes.languageSelection);
    } else {
      Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('errorSignIn').toString());
    }
  }
}
