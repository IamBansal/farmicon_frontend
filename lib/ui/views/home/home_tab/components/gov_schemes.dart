part of '../tab.dart';

List<Widget> buildGovSchemesSection(BuildContext context, HomeViewModel model) {
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
            AppLocalization.of(context).getTranslatedValue('governmentSchemes').toString().replaceAll('\n', ' '),
            style: AppTheme.h3.copyWith(
              color: AppTheme.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              model.homeTabRoute = HomeTabRoutes.govSchemes;
              Get.toNamed(
                HomeTabRoutes.govSchemes,
                arguments: model,
                id: 1,
              );
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
        child: (model.govSchemes.isEmpty)
            ? SizedBox(
                width: 330.r,
                height: 115.r,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                width: 330.r,
                padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 0),
                child: Column(
                  children: List<Widget>.generate(
                    min(model.govSchemes.length, 2),
                    (index) => SchemeInfoCard(
                      model.govSchemes[index],
                      squeeze: true,
                    ),
                  ),
                ),
              ),
      ),
    ),
  ];
}
