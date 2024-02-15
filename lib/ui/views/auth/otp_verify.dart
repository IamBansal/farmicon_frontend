import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../services/app_localizations.dart';
import '../../../viewmodels/otp_verify.dart';
import '../../app_theme.dart';
import '../../base.dart';
import '../../components/app_bar.dart';
import '../../components/text.dart';

class OtpVerifyView extends StatelessWidget {
  const OtpVerifyView(this._phoneNumber, {Key? key}) : super(key: key);

  final PhoneNumber _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BaseView<OtpVerifyViewModel>(
      onModelReady: (model) => model.onModelReady(_phoneNumber),
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildFarmiconAppBar(
            title: AppLocalization.of(context).getTranslatedValue('otpVerifyTitle').toString(),
            onPressed: Get.back,
          ),
          backgroundColor: AppTheme.white,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(height: 60.r),
                AText(
                  AppLocalization.of(context).getTranslatedValue('otpInstructionsLine3').toString(),
                  style: AppTheme.otpInstructionsStyle,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.r,
                    vertical: 16.r,
                  ),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    keyboardType: TextInputType.number,
                    autoFocus: true,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      activeColor: AppTheme.primary,
                      selectedColor: AppTheme.primary,
                      inactiveColor: AppTheme.lightText,
                    ),
                    onChanged: (newState) => model.otpCode = newState,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: AppLocalization.of(context).getTranslatedValue('expiresIn').toString(),
                        style: AppTheme.otpInstructionsStyle,
                      ),
                      TextSpan(
                        text: model.timeRemaining,
                        style: AppTheme.otpInstructionsStyle
                            .copyWith(color: AppTheme.primary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30.r, 0, 8.r),
                  child: SizedBox(
                    width: 80.r,
                    child: TextButton(
                      onPressed: () {model.submitOtpViaAWS(_phoneNumber);},
                      style: ButtonStyle(
                        backgroundColor: model.otpCode.length >= 6
                            ? const MaterialStatePropertyAll(AppTheme.primary)
                            : MaterialStatePropertyAll(
                                AppTheme.primary.withAlpha(154)),
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.zero),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r))),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Container(
                        height: 40.r,
                        alignment: Alignment.center,
                        child: AText(
                          AppLocalization.of(context).getTranslatedValue('submit').toString(),
                          style: AppTheme.h3,
                        ),
                      ),
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: AppLocalization.of(context).getTranslatedValue('resendOtp1').toString(),
                        style: AppTheme.otpInstructionsStyle,
                      ),
                      TextSpan(
                        text: AppLocalization.of(context).getTranslatedValue('resendOtp2').toString(),
                        style: AppTheme.otpInstructionsStyle.copyWith(
                          color: AppTheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => model.resendOtp(_phoneNumber),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
