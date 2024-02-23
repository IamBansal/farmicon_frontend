import 'dart:async';
import 'dart:math';
import 'package:aws_sns_api/sns-2010-03-31.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmicon/viewmodels/language_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_localizations.dart';
import '../core/router.dart';
import '../services/location.dart';

class OtpVerifyViewModel extends LanguageSelectionViewModel {
  // Data
  late String _otpCode;
  late Duration _timer;

  String accessKey = dotenv.env['AWS_ACCESS_KEY'] ?? '';
  String secretKey = dotenv.env['AWS_SECRET_KEY'] ?? '';

  // Getters
  String get timeRemaining {
    return '${_timer.inMinutes.toString().padLeft(2, '0')}'
        ':${(_timer.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String get otpCode => _otpCode;

  // Setters
  void decreaseTime() {
    if (_timer > Duration.zero) {
      _timer -= const Duration(seconds: 1);
      notifyListeners();
    }
  }

  set otpCode(String newState) {
    _otpCode = newState;
    notifyListeners();
  }

  // Initializer
  void onModelReady(PhoneNumber phoneNumber) {
    sendOtpViaAWS(phoneNumber);

    _timer = const Duration(minutes: 2);
    Timer.periodic(const Duration(seconds: 1), (timer) => decreaseTime());

    _otpCode = '';
  }
  final auth = FirebaseAuth.instance;

  var otpMade = 100000 + Random().nextInt(900000);
  void sendOtpViaAWS(PhoneNumber phoneNumber){
    try{
      otpMade = 100000 + Random().nextInt(900000);
      final service = SNS(region: 'ap-south-1', credentials: AwsClientCredentials(accessKey: accessKey, secretKey: secretKey));
      service.publish(message: 'Your OTP for log in to Farmicon is $otpMade\nThis otp is valid for 1 minute.', phoneNumber: '${phoneNumber.countryCode} ${phoneNumber.number}');
    } catch(e){
      debugPrint(e.toString());
    }
  }

  void submitOtpViaAWS(PhoneNumber phoneNumber, BuildContext context) async {
    if (_otpCode == (otpMade.toString())){
      try {
        await _createUser(phoneNumber, context);
        Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('successSignIn').toString());
        Get.toNamed(AppRoutes.home);
      } catch (e) {
        Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('errorSignIn').toString());
      }
    } else {
      Get.rawSnackbar(message:AppLocalization.of(Get.context!).getTranslatedValue('errorSignIn').toString());
    }
  }

  void resendOtp(PhoneNumber phoneNumber) {
    sendOtpViaAWS(phoneNumber);
  }

  Future<void> _createUser(PhoneNumber phoneNumber, BuildContext context) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('phone_number', isEqualTo: phoneNumber.number)
        .get();

    if (result.docs.isEmpty) {
      final authCred = await auth.signInAnonymously();
      final address = await LocationService.fetchAddress('en');

      saveUid(auth.currentUser!.uid.toString());

      return FirebaseFirestore.instance
          .collection('users')
          .add({
            'address': {
              'district': address?['district'] ?? '',
              'city': address?['city'] ?? '',
              'pincode': int.tryParse(address?['postcode']) ?? 0,
              'street_name': address?['street'] ?? '',
            },
        'uid': auth.currentUser!.uid.toString(),
            'crops-en': [],
            'crops-hi': [],
            'email': null,
            'name': auth.currentUser!.displayName,
            'phone_number': phoneNumber.number,
          })
          .then((value) => debugPrint('DB USER CREATED'))
          .catchError((error) => debugPrint('db user creation failed'));
    } else {
      saveUid(result.docs[0]['uid'].toString());
      await auth.signInAnonymously();
    }
  }

  void saveUid(String id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', id);
  }
}
