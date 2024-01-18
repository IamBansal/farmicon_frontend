part of '../tab.dart';

Widget buildCropIcon(BuildContext context, CropPrice crop) {
  final model = Provider.of<HomeViewModel>(context, listen: true);

  final image = Padding(
    padding: EdgeInsets.all(6.r),
    child: ClipOval(
      child: (model.imageUrlMap.containsKey(crop.name['en']))
          ? AImage(
              model.imageUrlMap[crop.name['en']]!,
              width: 60.r,
              height: 60.r,
            )
          : Container(
              color: AppTheme.lightPrimary,
              width: 60.r,
              height: 60.r,
              padding: EdgeInsets.all(10.r),
              child: SvgPicture.asset(AppAssets.leaf),
            ),
    ),
  );

  return Padding(
    padding: EdgeInsets.only(top: 12.r),
    child: GestureDetector(
      onTap: () => model.toggleCrop(
        crop.name['en']!,
        crop.variety['en']!,
      ),
      child: Column(
        children: <Widget>[
          (!crop.isBookmarked)
              ? image
              : Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    image,
                    SvgPicture.asset(
                      AppAssets.checkCircle,
                      width: 32.r,
                    ),
                  ],
                ),
          AText(
            crop.name[AppLocalization.of(context).locale]!,
            style:
                AppTheme.otpInstructionsStyle.copyWith(color: AppTheme.grey100),
          ),
        ],
      ),
    ),
  );
}
