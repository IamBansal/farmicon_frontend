import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme.dart';
import 'text.dart';

AppBar buildFarmiconAppBar({
  required String title,
  required VoidCallback onPressed,
}) {
  return AppBar(
    title: Padding(
      padding: const EdgeInsets.only(top: 6),
      child: AText(
        title,
        style: AppTheme.appBarStyle,
      ),
    ),
    backgroundColor: AppTheme.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.chevron_left,
        color: AppTheme.black,
      ),
      iconSize: 30.r,
      onPressed: onPressed,
    ),
    leadingWidth: 30.r,
  );
}
