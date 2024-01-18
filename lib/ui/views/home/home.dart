import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_localizations.dart';
import '../../../utils/nav_utils.dart';
import '../../../viewmodels/home.dart';
import '../../app_theme.dart';
import '../../base.dart';
import '../../components/app_bar.dart';
import '../../components/bottom_nav_bar.dart';
import 'home_tab/tab.dart';
import 'language_tab/tab.dart';
import 'notification_tab/tab.dart';
import 'profile_tab/tab.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar? buildAppBar(HomeViewModel model) {
      String? tabTitle;

      switch (model.tabIndex) {
        case 0:
          switch (getCurrentRoute(Get.keys[1])) {
            case HomeTabRoutes.price:
              tabTitle = AppLocalization.of(context).getTranslatedValue('cropPrice').toString();
              break;
            case HomeTabRoutes.insurance:
              tabTitle = AppLocalization.of(context).getTranslatedValue('cropInsurance').toString();
              break;
            case HomeTabRoutes.doctor:
              tabTitle = AppLocalization.of(context).getTranslatedValue('cropDoctor').toString();
              break;
            case HomeTabRoutes.drone:
              tabTitle = AppLocalization.of(context).getTranslatedValue('drone').toString();
              break;
            case HomeTabRoutes.soilTesting:
              tabTitle = AppLocalization.of(context).getTranslatedValue('soilTesting').toString();
              break;
            case HomeTabRoutes.govSchemes:
              tabTitle = AppLocalization.of(context).getTranslatedValue('governmentSchemes').toString().replaceAll('\n', ' ');
              break;
            case HomeTabRoutes.orgFarming:
              tabTitle = AppLocalization.of(context).getTranslatedValue('organicFarming').toString().replaceAll('\n', ' ');
              break;
            case HomeTabRoutes.weather:
              tabTitle = AppLocalization.of(context).getTranslatedValue('weatherPageTitle').toString();
              break;
            case HomeTabRoutes.warehouse:
              tabTitle = AppLocalization.of(context).getTranslatedValue('warehouse').toString();
              break;
          }
          break;
        case 1:
          tabTitle = AppLocalization.of(context).getTranslatedValue('languageTabLabel').toString();
          break;
        case 2:
          switch (model.profileTabRoute) {
            case ProfileTabRoutes.profile:
              tabTitle = AppLocalization.of(context).getTranslatedValue('profileTabLabel').toString();
              break;
            case ProfileTabRoutes.selectCrops:
              tabTitle = AppLocalization.of(context).getTranslatedValue('selectCrops').toString();
          }
          break;
        case 3:
          tabTitle = AppLocalization.of(context).getTranslatedValue('notificationTabLabel').toString();
          break;
        default:
          tabTitle = AppLocalization.of(context).getTranslatedValue('homeTabLabel').toString();
      }

      if (tabTitle == null) return null;

      return buildFarmiconAppBar(
        title: tabTitle,
        onPressed: () {
          if (model.tabIndex == 0) {
            model.homeTabRoute = HomeTabRoutes.home;
            Get.back(id: 1);
          } else if ((model.tabIndex == 2) &&
              (model.profileTabRoute != ProfileTabRoutes.profile)) {
            model.profileTabRoute = ProfileTabRoutes.profile;
            Get.back(id: 2);
          } else {
            model.setTabIndex(0);
          }
        },
      );
    }

    Widget buildBody(BuildContext contextWithVM, HomeViewModel model) {
      switch (model.tabIndex) {
        case 1:
          return buildLanguageTab(contextWithVM);
        case 2:
          return buildProfileTab(contextWithVM);
        case 3:
          return buildNotificationTab(contextWithVM);
        default:
          return buildHomeTab(contextWithVM);
      }
    }

    return BaseView<HomeViewModel>(
      onModelReady: (model) => model.onModelReady(),
      builder: (contextWithViewModel, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (model.tabIndex == 0) {
              if (model.homeTabRoute != HomeTabRoutes.home) {
                model.homeTabRoute = HomeTabRoutes.home;
                Get.back(id: 1);
              } else {
                return true;
              }
            } else if ((model.tabIndex == 2) &&
                (model.profileTabRoute != ProfileTabRoutes.profile)) {
              model.profileTabRoute = ProfileTabRoutes.profile;
              Get.back(id: 2);
            } else {
              model.setTabIndex(0);
            }
            return false;
          },
          child: Scaffold(
            appBar: buildAppBar(model),
            backgroundColor: AppTheme.white,
            body: buildBody(contextWithViewModel, model),
            bottomNavigationBar: buildBNB(contextWithViewModel, model),
          ),
        );
      },
    );
  }
}
