import 'package:flutter/material.dart';
import '../models/doctor_result.dart';
import '../services/app_localizations.dart';

String enumToString(ResultStatus status, BuildContext context) {
  if (status == ResultStatus.pending) {
    return AppLocalization.of(context).getTranslatedValue('statusPending').toString();
  } else {
    return AppLocalization.of(context).getTranslatedValue('statusComplete').toString();
  }
}
