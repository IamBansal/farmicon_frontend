part of '../tab.dart';

List<Widget> buildShortcuts(BuildContext context) {
  Widget buildGridChild({
    required String asset,
    required String text,
    required VoidCallback onPressed,
    bool empty = false,
  }) {
    return SizedBox(
      height: 150.r,
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: empty ? AppTheme.white : AppTheme.lightPrimary,
              ),
              child: empty
                  ? null
                  : Padding(
                      padding: EdgeInsets.all(8.r),
                      child: SvgPicture.asset(asset),
                    ),
            ),
            SizedBox(height: 10.r),
            AText(
              text,
              style: AppTheme.countryCodeStyle
                  .copyWith(fontFamily: 'Lato', fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  final model = Provider.of<HomeViewModel>(context, listen: true);

  return <Widget>[
    Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25.r,
        vertical: 20.r,
      ),
      child: AText(
        AppLocalization.of(context).getTranslatedValue('homePageSubtitle1').toString(),
        style: AppTheme.h3.copyWith(
          color: AppTheme.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 55.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildGridChild(
            asset: AppAssets.cropDoctor,
            text: AppLocalization.of(context).getTranslatedValue('cropDoctor').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.doctor;
              Get.toNamed(HomeTabRoutes.doctor, arguments: model, id: 1);
            },
          ),
          buildGridChild(
            asset: AppAssets.weather,
            text: AppLocalization.of(context).getTranslatedValue('weather').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.weather;
              Get.toNamed(HomeTabRoutes.weather, arguments: model, id: 1);
            },
          ),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 55.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildGridChild(
            asset: AppAssets.drone,
            text: AppLocalization.of(context).getTranslatedValue('drone').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.drone;
              Get.toNamed(HomeTabRoutes.drone, arguments: model, id: 1);
            },
          ),
          buildGridChild(
            asset: AppAssets.warehouse,
            text: AppLocalization.of(context).getTranslatedValue('warehouse').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.warehouse;
              Get.toNamed(HomeTabRoutes.warehouse, arguments: model, id: 1);
            },
          ),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 55.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildGridChild(
            asset: AppAssets.cropInsurance,
            text: AppLocalization.of(context).getTranslatedValue('cropInsurance').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.insurance;
              Get.toNamed(HomeTabRoutes.insurance, arguments: model, id: 1);
            },
          ),
          buildGridChild(
            asset: AppAssets.soilTesting,
            text: AppLocalization.of(context).getTranslatedValue('soilTesting').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.soilTesting;
              Get.toNamed(HomeTabRoutes.soilTesting, arguments: model, id: 1);
            },
          ),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 55.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildGridChild(
            asset: AppAssets.governmentSchemes,
            text: AppLocalization.of(context).getTranslatedValue('governmentSchemes').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.govSchemes;
              Get.toNamed(HomeTabRoutes.govSchemes, arguments: model, id: 1);
            },
          ),
          buildGridChild(
            asset: AppAssets.organicFarming,
            text: AppLocalization.of(context).getTranslatedValue('organicFarming').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.orgFarming;
              Get.toNamed(HomeTabRoutes.orgFarming, arguments: model, id: 1);
            },
          ),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 55.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildGridChild(
            asset: AppAssets.cropPrice,
            text: AppLocalization.of(context).getTranslatedValue('cropPrice').toString(),
            onPressed: () {
              model.homeTabRoute = HomeTabRoutes.price;
              Get.toNamed(HomeTabRoutes.price, arguments: model, id: 1);
            },
          ),
          buildGridChild(
            asset: AppAssets.organicFarming,
            text: '',
            empty: true,
            onPressed: () {},
          ),
        ],
      ),
    ),
  ];
}
