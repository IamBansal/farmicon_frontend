import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../services/app_localizations.dart';
import '../../../../constants/app_assets.dart';
import '../../../../viewmodels/home.dart';
import '../../../app_theme.dart';
import '../../../components/language_radio_button.dart';
import '../../../components/text.dart';

Widget buildLanguageTab(BuildContext context) {
  final model = Provider.of<HomeViewModel>(context, listen: true);

  return SafeArea(
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
                style: AppTheme.h1.copyWith(fontWeight: FontWeight.w500),
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
                restart: true,
              ),
              SizedBox(width: 24.r),
              getRadioButton(
                model,
                context: context,
                value: 'hi',
                title: 'हिन्दी',
                restart: true,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
