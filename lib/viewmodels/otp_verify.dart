import 'dart:async';
import 'dart:math';
import 'package:aws_sns_api/sns-2010-03-31.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../services/app_localizations.dart';
import '../core/router.dart';
import '../services/location.dart';
import 'base.dart';

class OtpVerifyViewModel extends BaseViewModel {
  // Data
  int? _resendToken;
  late String _otpCode;
  late String? _verificationId;
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
    // sendOtp(phoneNumber);
    sendOtpViaAWS(phoneNumber);

    _timer = const Duration(minutes: 2);
    Timer.periodic(const Duration(seconds: 1), (timer) => decreaseTime());

    _otpCode = '';
  }
  final auth = FirebaseAuth.instance;

  var otpMade = 100000 + Random().nextInt(900000);
  void sendOtpViaAWS(PhoneNumber phoneNumber){
    otpMade = 100000 + Random().nextInt(900000);
    final service = SNS(region: 'ap-south-1', credentials: AwsClientCredentials(accessKey: accessKey, secretKey: secretKey));
    service.publish(message: 'Your OTp for log in to Farmicon is $otpMade\nThis otp is valid for 1 minute.', phoneNumber: '${phoneNumber.countryCode} ${phoneNumber.number}');
  }

  void submitOtpViaAWS(PhoneNumber phoneNumber) async {
    if (_otpCode == (otpMade.toString())){
      try {
        await auth.signInAnonymously();
        await _createUser(phoneNumber);
        Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('successSignIn').toString());
        Get.toNamed(AppRoutes.home);
      } catch (_) {
        Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('errorSignIn').toString());
      }
    } else {
      Get.rawSnackbar(message:AppLocalization.of(Get.context!).getTranslatedValue('errorSignIn').toString());
    }
  }

  // void sendOtp(PhoneNumber phoneNumber, {bool isSecondTime = false}) {
  //   auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber.completeNumber,
  //     verificationCompleted: (phoneAuthCredential) async {
  //       // _verificationId = phoneAuthCredential.verificationId;
  //       // if (phoneAuthCredential.smsCode != null) {
  //       //   _otpCode = phoneAuthCredential.smsCode!;
  //       // }
  //       //
  //       // await auth.signInWithCredential(phoneAuthCredential);
  //       //
  //       // await _createUser();
  //       //
  //       // Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('successSignIn').toString());
  //       // Get.offAllNamed(AppRoutes.languageSelection);
  //     },
  //     forceResendingToken: isSecondTime ? _resendToken : null,
  //     codeSent: (verificationId, resendToken) {
  //       _verificationId = verificationId;
  //       _resendToken = resendToken;
  //     },
  //     codeAutoRetrievalTimeout: (_) {},
  //     timeout: const Duration(minutes: 2),
  //     verificationFailed: (FirebaseAuthException error) {
  //       // Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('errorSignIn').toString());
  //     },
  //   );
  // }
  //
  // // Misc
  // void submitOtp() async {
  //   if (_verificationId != null && _otpCode.length >= 6) {
  //     final phoneAuthCredential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId!,
  //       smsCode: _otpCode,
  //     );
  //
  //     try {
  //       await auth.signInWithCredential(phoneAuthCredential);
  //
  //       // await _createUser(pho);
  //
  //       Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('successSignIn').toString());
  //       Get.toNamed(AppRoutes.home);
  //     } catch (_) {
  //       Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('errorSignIn').toString());
  //     }
  //   } else {
  //     Get.rawSnackbar(message:AppLocalization.of(Get.context!).getTranslatedValue('errorSignIn').toString());
  //   }
  // }

  void resendOtp(PhoneNumber phoneNumber) {
    // if (_resendToken != null) sendOtp(phoneNumber, isSecondTime: true);
    sendOtpViaAWS(phoneNumber);
  }

  Future<void> _createUser(PhoneNumber phoneNumber) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('phone_number', isEqualTo: phoneNumber.number)
        .get();

    if (result.docs.isEmpty) {
      final address = await LocationService.fetchAddress('en');

      return FirebaseFirestore.instance
          .collection('users')
          .add({
            'address': {
              'district': address?['district'] ?? '',
              'city': address?['city'] ?? '',
              'pincode': int.tryParse(address?['postcode']) ?? 0,
              'street_name': address?['street'] ?? '',
            },
            'crops-en': [],
            'crops-hi': [],
            'email': null,
            'name': auth.currentUser!.displayName,
            'phone_number': phoneNumber.number,
          })
          .then((value) => debugPrint('DB USER CREATED'))
          .catchError((error) => debugPrint('db user creation failed'));
    }
  }
}
