import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_assets.dart';
import '../../core/router.dart';
import '../../services/app_localizations.dart';
import '../../viewmodels/language_selection.dart';
import '../app_theme.dart';
import '../base.dart';
import '../components/language_radio_button.dart';
import '../components/text.dart';

class LanguageSelectionView extends StatelessWidget {
  const LanguageSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LanguageSelectionViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppTheme.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.r, 50.r, 24.r, 50.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(AppAssets.logo, height: 40.r),
                      SizedBox(width: 8.r),
                      AText(
                        AppLocalization.of(context).getTranslatedValue('greeting').toString(),
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.h1.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.r),
                  AText(
                    AppLocalization.of(context).getTranslatedValue('selectLanguage').toString(),
                    style: AppTheme.selectLanguageStyle,
                  ),
                  SizedBox(height: 24.r),
                  Row(
                    children: <Widget>[
                      getRadioButton(
                        model,
                        context: context,
                        value: 'en',
                        title: 'English',
                      ),
                      SizedBox(width: 24.r),
                      getRadioButton(
                        model,
                        context: context,
                        value: 'hi',
                        title: 'हिन्दी',
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 80.r,
                      child: TextButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.home);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(AppTheme.primary),
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
                            AppLocalization.of(context).getTranslatedValue('submit').toString(),
                            style: AppTheme.h3,
                          ),
                        ),
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
