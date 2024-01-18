import 'package:farmicon_frontend/app_localizations.dart';
import 'package:flutter/material.dart';
import '../core/locator.dart';
import '../services/local_storage.dart';

class LanguageProvider extends ChangeNotifier {
  //Services:
  final _localStorageService = locator<LocalStorageService>();

  //Data:
  late Locale _locale;

  //Getters:
  Locale get locale => Locale(_localStorageService.language);

  //Setters:
  void setLocale(String languageCode) async {
    if (Locale(languageCode) != _locale) {
      _locale = Locale(languageCode);
      _localStorageService.language = languageCode;
      await AppLocalization.delegate.load(_locale);
      notifyListeners();
    }
  }

  void initialize() {
    _locale = Locale(_localStorageService.language);
  }
}
