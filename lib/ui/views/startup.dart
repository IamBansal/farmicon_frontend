import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_assets.dart';
import '../../viewmodels/startup.dart';
import '../app_theme.dart';
import '../base.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<StartUpViewModel>(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppTheme.white,
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 80.r),
                Image.asset(
                  AppAssets.logo,
                  height: 140.r,
                ),
                SizedBox(height: 10.r),
                Image.asset(
                  AppAssets.title,
                  height: 63.r,
                ),
                const Spacer(),
                SvgPicture.asset(
                  AppAssets.footer,
                  width: 1.sw,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
