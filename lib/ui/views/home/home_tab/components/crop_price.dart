part of '../tab.dart';

List<Widget> buildCropPriceSection(BuildContext context, HomeViewModel model) {
  return <Widget>[
    Padding(
      padding: EdgeInsets.fromLTRB(
        25.r,
        32.r,
        36.r,
        15.r,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AText(
            AppLocalization.of(context).getTranslatedValue('cropPrice').toString(),
            style: AppTheme.h3.copyWith(
              color: AppTheme.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              model.homeTabRoute = HomeTabRoutes.price;
              Get.toNamed(HomeTabRoutes.price, arguments: model, id: 1);
            },
            child: AText(
              AppLocalization.of(context).getTranslatedValue('showAll').toString(),
              style: AppTheme.otpInstructionsStyle.copyWith(
                color: AppTheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    ),
    Align(
      alignment: Alignment.center,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8.r),
        type: MaterialType.card,
        color: AppTheme.dirtyWhite,
        child: (model.allCrops == null)
            ? SizedBox(
                width: 330.r,
                height: 115.r,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                width: 330.r,
                padding: EdgeInsets.symmetric(horizontal: 21.r, vertical: 8.r),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    min(model.allCrops?.length ?? 0, 3),
                    (index) => _buildCropPriceMiniCard(
                      context,
                      model,
                      model.allCrops![index],
                    ),
                  ),
                ),
              ),
      ),
    ),
  ];
}

Widget _buildCropPriceMiniCard(
  BuildContext context,
  HomeViewModel model,
  CropPrice crop,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      ClipOval(
        child: (model.imageUrlMap.containsKey(crop.name['en']!))
            ? AImage(
                model.imageUrlMap[crop.name['en']!]!,
                width: 60.r,
              )
            : Container(
                color: AppTheme.lightPrimary,
                width: 60.r,
                height: 60.r,
                padding: EdgeInsets.all(10.r),
                child: SvgPicture.asset(AppAssets.leaf, width: 60),
              ),
      ),
      SizedBox(height: 2.r),
      AText(
        crop.name[AppLocalization.of(context).locale]!,
        style: AppTheme.otpInstructionsStyle.copyWith(color: AppTheme.text),
        maxLines: 1,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 4.r),
      SizedBox(
        width: 70.r,
        child: AText(
          '${crop.price.round()}/${crop.unitShort[AppLocalization.of(context).locale]}',
          overflow: TextOverflow.clip,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: AppTheme.otpInstructionsStyle.copyWith(
            color: AppTheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
