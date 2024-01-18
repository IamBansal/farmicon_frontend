part of '../tab.dart';

List<Widget> buildMyCropsCard(BuildContext context) {
  Widget getCropIcon({
    required String hi,
    required String en,
    String? url,
    VoidCallback? onPressed,
  }) {
    if (en.contains(',')) {
      en = en.substring(0, en.indexOf(','));
      hi = hi.substring(0, hi.indexOf(','));
    }
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          ClipOval(
            child: (url != null)
                ? AImage(
                    url,
                    width: 48.r,
                  )
                : Container(
                    color: AppTheme.lightPrimary,
                    width: 48.r,
                    height: 48.r,
                    padding: EdgeInsets.all(10.r),
                    child: SvgPicture.asset(AppAssets.leaf),
                  ),
          ),
          AText(
            AppLocalization.of(context).locale.languageCode == 'en' ? en : hi,
            style: AppTheme.readMoreStyle.copyWith(
              color: AppTheme.primary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  final model = Provider.of<HomeViewModel>(context, listen: true);

  return <Widget>[
    Padding(
      padding: EdgeInsets.fromLTRB(
        8.r,
        24.r,
        8.r,
        15.r,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AText(
            AppLocalization.of(context).getTranslatedValue('myCrops').toString(),
            style: AppTheme.h3.copyWith(
              color: AppTheme.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              model.profileTabRoute = ProfileTabRoutes.selectCrops;
              Get.toNamed(ProfileTabRoutes.selectCrops, id: 2);
            },
            child: AText(
              AppLocalization.of(context).getTranslatedValue('addMore').toString(),
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
        child: Container(
          padding: EdgeInsets.all(8.r),
          width: double.infinity,
          child: GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            childAspectRatio: 1.9.sw / 1.sh,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              for (int i = 0; i < model.user.cropsEn.length; i++)
                getCropIcon(
                  en: model.user.cropsEn[i],
                  hi: model.user.cropsHi[i],
                  url: model.imageUrlMap[model.user.cropsEn[i]],
                ),
              getCropIcon(
                hi: AppLocalization.of(context).getTranslatedValue('addMoreCrops').toString(),
                en: AppLocalization.of(context).getTranslatedValue('addMoreCrops').toString(),
                onPressed: () {
                  model.profileTabRoute = ProfileTabRoutes.selectCrops;
                  Get.toNamed(ProfileTabRoutes.selectCrops, id: 2);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  ];
}
