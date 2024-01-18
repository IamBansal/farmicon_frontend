part of '../tab.dart';

Widget buildUpdateCropsButton(BuildContext context) {
  final model = Provider.of<HomeViewModel>(context, listen: true);

  return ElevatedButton(
    onPressed: () async {
      model.profileTabRoute = ProfileTabRoutes.profile;
      Get.back(id: 2);
    },
    style: ButtonStyle(
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
        ),
      ),
      textStyle: const MaterialStatePropertyAll(AppTheme.h3),
    ),
    child: AText(AppLocalization.of(context).getTranslatedValue('addCrops').toString()),
  );
}
