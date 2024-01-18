import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app_localizations.dart';
import '../../constants/app_assets.dart';
import '../../viewmodels/home.dart';
import '../app_theme.dart';

Widget buildBNB(BuildContext context, HomeViewModel model) {
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            AppAssets.house,
            width: 24.r,
          ),
        ),
        label: AppLocalization.of(context).getTranslatedValue('homeTabLabel').toString(),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            AppAssets.language,
            width: 24.r,
          ),
        ),
        label: AppLocalization.of(context).getTranslatedValue('languageTabLabel').toString(),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            AppAssets.user,
            width: 24.r,
          ),
        ),
        label: AppLocalization.of(context).getTranslatedValue('profileTabLabel').toString(),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            AppAssets.bell,
            width: 24.r,
          ),
        ),
        label: AppLocalization.of(context).getTranslatedValue('notificationTabLabel').toString(),
      ),
    ],
    backgroundColor: AppTheme.ceramic,
    elevation: 0,
    currentIndex: model.tabIndex,
    onTap: model.setTabIndex,
    type: BottomNavigationBarType.fixed,
  );
}
