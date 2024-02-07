import 'dart:io';
import 'package:farmicon/services/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'constants/enums/connectivity_status.dart';
import 'core/locator.dart';
import 'core/router.dart';
import 'services/api.dart';
import 'services/connectivity.dart';
import 'services/notification.dart';
import 'ui/app_theme.dart';
import 'ui/views/startup.dart';
import 'viewmodels/language.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await FlutterConfig.loadEnvVariables();
  HttpOverrides.global = MyHttpOverrides();
  await setupLocator();
  await Firebase.initializeApp();
  ApiService.init();
  NotificationService.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(Phoenix(child: const Farmicon()));
}

class Farmicon extends StatelessWidget {
  const Farmicon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set notification bar color.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppTheme.white,
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider()..initialize(),
          ),
          StreamProvider<ConnectivityStatus>(
            create: (_) =>
            ConnectivityService().connectionStatusController?.stream,
            initialData: ConnectivityStatus.online,
          ),
        ],
        child: Consumer<LanguageProvider>(
          builder: (context, model, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: const StartUpView(),
              locale: model.locale,
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale!.languageCode &&
                      locale.countryCode == deviceLocale.countryCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalization.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('hi', 'IN'),
              ],
              navigatorObservers: <NavigatorObserver>[
                SentryNavigatorObserver(),
              ],
              onGenerateRoute: AppRouter.generateRoute,
              title: 'Security App',
              theme: AppTheme.theme,
            );
          },
        ),
      ),
    );
  }
}