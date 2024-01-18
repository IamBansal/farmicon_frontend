import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../app_localizations.dart';
import '../../../constants/app_assets.dart';
import '../../../viewmodels/login.dart';
import '../../app_theme.dart';
import '../../base.dart';
import '../../components/text.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppTheme.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 60.r, bottom: 28.r),
                    child: Image.asset(AppAssets.logo, height: 80.r),
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(text: 'Welcome to ', style: AppTheme.h1),
                        TextSpan(
                          text: 'Farmicon',
                          style: AppTheme.h1.copyWith(color: AppTheme.primary),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.r, 28.r, 24.r, 16.r),
                    child: IntlPhoneField(
                      initialCountryCode: 'IN',
                      onChanged: (pN) => model.phoneNumber = pN,
                      onCountryChanged: model.setCountry,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      dropdownTextStyle: AppTheme.countryCodeStyle,
                      style: AppTheme.phoneNumberInputStyle,
                      dropdownIcon: const Icon(Icons.keyboard_arrow_down),
                      dropdownIconPosition: IconPosition.trailing,
                      flagsButtonPadding: const EdgeInsets.only(left: 16),
                    ),
                  ),
                  AText(
                    AppLocalization.of(context).getTranslatedValue('otpInstructionsLine1').toString(),
                    textAlign: TextAlign.center,
                    style: AppTheme.otpInstructionsStyle,
                  ),
                  AText(
                    AppLocalization.of(context).getTranslatedValue('otpInstructionsLine2').toString(),
                    textAlign: TextAlign.center,
                    style: AppTheme.otpInstructionsStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.r),
                    child: SizedBox(
                      width: 110.r,
                      child: TextButton(
                        onPressed: model.phoneNumber.number.length >= 10
                            ? model.sendOtp
                            : null,
                        style: ButtonStyle(
                          backgroundColor: model.phoneNumber.number.length >= 10
                              ? const MaterialStatePropertyAll(AppTheme.primary)
                              : MaterialStatePropertyAll(
                                  AppTheme.primary.withAlpha(154)),
                          padding:
                              const MaterialStatePropertyAll(EdgeInsets.zero),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r))),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Container(
                          height: 40.r,
                          alignment: Alignment.center,
                          child: AText(
                            AppLocalization.of(context).getTranslatedValue('sendOtp').toString(),
                            style: AppTheme.h3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.r),
                    child: AText(
                      'Or',
                      style: AppTheme.h1.copyWith(fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 180.r,
                    child: TextButton(
                      onPressed: model.googleSignIn,
                      style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xFFD9D9D9)),
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.zero),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            AppAssets.googleLogo,
                            width: 20.r,
                          ),
                          SizedBox(
                            width: 16.r,
                            height: 48.r,
                          ),
                          AText(
                            AppLocalization.of(context).getTranslatedValue('googleButton').toString(),
                            style: AppTheme.googleButtonStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
