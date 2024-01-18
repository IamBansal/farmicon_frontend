part of '../tab.dart';

List<Widget> buildLocationSection(BuildContext context) {
  final model = Provider.of<HomeViewModel>(context, listen: true);

  return <Widget>[
    Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
        8.r,
        18.r,
        8.r,
        15.r,
      ),
      child: AText(
        AppLocalization.of(context).getTranslatedValue('location').toString(),
        style: AppTheme.h3.copyWith(
          color: AppTheme.text,
          fontWeight: FontWeight.w600,
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: model.useCurrentLocation,
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      AppAssets.crosshair,
                      width: 18.r,
                    ),
                    const SizedBox(width: 8),
                    AText(
                      AppLocalization.of(context).getTranslatedValue('useCurrentLocation').toString(),
                      style: AppTheme.vendorDataTitleStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.r),
              TextInput(
                initialValue: model.user.address.streetName,
                hint: AppLocalization.of(context).getTranslatedValue('streetName').toString(),
                controller: model.streetName,
                onChanged: (_) => model.updateAddress(),
                width: double.infinity,
              ),
              SizedBox(height: 8.r),
              Row(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextInput(
                    initialValue: model.user.address.city,
                    hint: AppLocalization.of(context).getTranslatedValue('city').toString(),
                    controller: model.city,
                    onChanged: (_) => model.updateAddress(),
                    width: 0.45.sw,
                  ),
                  const Spacer(),
                  TextInput(
                    initialValue: model.user.address.district,
                    hint: AppLocalization.of(context).getTranslatedValue('district').toString(),
                    controller: model.district,
                    onChanged: (_) => model.updateAddress(),
                    width: 0.4.sw,
                  ),
                ],
              ),
              SizedBox(height: 8.r),
              TextInput(
                initialValue: model.user.address.pincode.toString(),
                hint: AppLocalization.of(context).getTranslatedValue('pincode').toString(),
                controller: model.pincode,
                onChanged: (_) => model.updateAddress(),
                width: 0.45.sw,
                maxLength: 6,
                keyboard: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    ),
  ];
}
