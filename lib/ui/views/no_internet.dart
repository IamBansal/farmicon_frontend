import 'package:farmicon_frontend/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_assets.dart';
import '../app_theme.dart';
import '../components/text.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                AppAssets.noInternet,
                height: 160.r,
              ),
              SizedBox(height: 20.h),
              AText(
                AppLocalization.of(context).getTranslatedValue('noInternet1').toString(),
              ),
              AText(
                  AppLocalization.of(context).getTranslatedValue('noInternet2').toString(),
                softWrap: true,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
