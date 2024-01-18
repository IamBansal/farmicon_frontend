import 'package:get_it/get_it.dart';

import '../services/local_storage.dart';
import '../viewmodels/home.dart';
import '../viewmodels/language_selection.dart';
import '../viewmodels/login.dart';
import '../viewmodels/otp_verify.dart';
import '../viewmodels/startup.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final localStorageService = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(localStorageService);

  locator.registerFactory(() => StartUpViewModel());
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => OtpVerifyViewModel());
  locator.registerFactory(() => LanguageSelectionViewModel());
  locator.registerFactory(() => HomeViewModel());
}
