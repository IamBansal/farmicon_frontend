import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../core/locator.dart';
import '../services/local_storage.dart';
import 'base.dart';
import 'language.dart';

class LanguageSelectionViewModel extends BaseViewModel {
  // Getters
  String get languageCode => locator<LocalStorageService>().language;

  // String id = '';
  // void setId(String userId){
  //   id = userId;
  //   notifyListeners();
  // }

  // Setters
  void onButtonPressed(
    String? newLanguageCode,
    BuildContext context, {
    bool restart = false,
  }) {
    if (newLanguageCode != null) {
      Provider.of<LanguageProvider>(
        context,
        listen: false,
      ).setLocale(newLanguageCode);
    }
    if (restart) {
      Get.deleteAll(force: true).then((_) {
        Phoenix.rebirth(Get.context!);
        Get.reset();
        Get.appUpdate();
        Get.forceAppUpdate();
      });
    } else {
      notifyListeners();
    }
  }
}
