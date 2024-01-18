import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../ui/app_theme.dart';
import '../ui/components/text.dart';
import '../ui/views/auth/login.dart';
import '../ui/views/auth/otp_verify.dart';
import '../ui/views/home/home.dart';
import '../ui/views/language_selection.dart';
import '../ui/views/startup.dart';

class AppRoutes {
  static const String startup = '/',
      home = '/home',
      login = '/login',
      otpVerify = '/otp_verify',
      languageSelection = '/language_selection';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.startup:
        return GetPageRoute(
          page: StartUpView.new,
          routeName: AppRoutes.startup,
          settings: settings,
        );
      case AppRoutes.login:
        return GetPageRoute(
          page: LoginView.new,
          routeName: AppRoutes.login,
          settings: settings,
        );
      case AppRoutes.otpVerify:
        return GetPageRoute(
          page: () => OtpVerifyView(settings.arguments as PhoneNumber),
          routeName: AppRoutes.otpVerify,
          settings: settings,
        );
      case AppRoutes.languageSelection:
        return GetPageRoute(
          page: LanguageSelectionView.new,
          routeName: AppRoutes.languageSelection,
          settings: settings,
        );
      case AppRoutes.home:
        return GetPageRoute(
          page: HomeView.new,
          routeName: AppRoutes.home,
          settings: settings,
        );
      // Default
      default:
        return GetPageRoute(
          page: () => Scaffold(
            backgroundColor: AppTheme.white,
            body: Center(
              child: AText('No route defined for ${settings.name}'),
            ),
          ),
          routeName: '/undefined',
        );
    }
  }
}
