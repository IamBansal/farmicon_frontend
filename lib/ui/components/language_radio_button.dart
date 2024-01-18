import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../viewmodels/language_selection.dart';
import '../app_theme.dart';
import 'text.dart';

NeumorphicRadio<String> getRadioButton(
  LanguageSelectionViewModel model, {
  required BuildContext context,
  required String value,
  required String title,
  bool restart = false,
}) {
  return NeumorphicRadio<String>(
    style: const NeumorphicRadioStyle(
      unselectedColor: AppTheme.dirtyWhite,
      selectedColor: AppTheme.lightPrimary,
      shape: NeumorphicShape.flat,
    ),
    value: value,
    onChanged: (language) => model.onButtonPressed(
      language,
      context,
      restart: restart,
    ),
    groupValue: model.languageCode,
    child: Container(
      height: 64.r,
      width: 80.r,
      alignment: Alignment.center,
      child: AText(
        title,
        style: AppTheme.h3.copyWith(color: AppTheme.text),
        textAlign: TextAlign.center,
        forceHindi: value == 'hi',
      ),
    ),
  );
}
