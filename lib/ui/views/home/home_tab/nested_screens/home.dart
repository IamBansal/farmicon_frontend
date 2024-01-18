part of '../tab.dart';

class HomeSubpage extends StatelessWidget {
  const HomeSubpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeViewModel>(context, listen: true);

    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          SvgPicture.asset(AppAssets.header, width: 1.sw),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...buildWeatherAndLocation(context, model),
              ...buildShortcuts(context),
              ...buildCropPriceSection(context, model),
              ...buildGovSchemesSection(context, model),
              ...buildOrgFarmingSection(context, model),
              SizedBox(height: 30.r),
            ],
          ),
        ],
      ),
    );
  }
}
