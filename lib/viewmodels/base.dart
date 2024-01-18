import 'package:flutter/foundation.dart';

import '../constants/enums/view_state.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  // ignore: unnecessary_getters_setters
  ViewState get state => _state;

  set state(ViewState newState) {
    _state = newState;
  }

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }
}
