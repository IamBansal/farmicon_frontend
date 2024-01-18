import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/home.dart';
import '../../../app_theme.dart';
import '../../../components/scheme_info_card.dart';

Widget buildNotificationTab(BuildContext context) {
  final model = Provider.of<HomeViewModel>(context, listen: true);

  if (model.orgFarmingTips.isEmpty && model.govSchemes.isEmpty) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primary,
      ),
    );
  }

  var list = model.orgFarmingTips + model.govSchemes;
  list.sort((a, b) => a.createdAt.compareTo(b.createdAt));

  return ListView(
    padding: EdgeInsets.fromLTRB(15.r, 0, 15.r, 15.r),
    children: List<Widget>.generate(
      list.length,
      (index) => SchemeInfoCard(list[index]),
    ),
  );
}
