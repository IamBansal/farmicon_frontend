part of '../tab.dart';

List<Widget> buildWeatherAndLocation(
  BuildContext context,
  HomeViewModel model,
) {
  final tip = model.weather.dailyTip[AppLocalization.of(context).locale];

  return <Widget>[
    Padding(
      padding: EdgeInsets.only(top: 30.r, left: 21.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(AppAssets.mapPin, width: 16.r),
          AText(
            model.locationText,
            style: AppTheme.selectLanguageStyle.copyWith(
              fontWeight: FontWeight.w400,
              color: const Color(0xFF949494),
            ),
          ),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.only(
        left: 40.r,
        right: 27.r,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  AText(
                    model.weather.temperature.toString(),
                    style: AppTheme.h0,
                  ),
                  AText(
                    '°C',
                    style: AppTheme.h0.copyWith(fontSize: 24),
                  ),
                  SizedBox(width: 20.r),
                  SvgPicture.asset(
                    AppAssets.humidity,
                    width: 16.r,
                  ),
                  AText(
                    '${model.weather.humidity}%',
                    style: AppTheme.selectLanguageStyle
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 16.r),
              AText(
                DateFormat('EEE, d MMM').format(DateTime.now()),
                style: AppTheme.otpInstructionsStyle,
              ),
            ],
          ),
          Column(
            children: <Widget>[
              if (model.weather.weatherIcon != null)
                SvgPicture.asset(
                  model.weather.weatherIcon!,
                  width: 90.r,
                )
              else
                SizedBox(
                  width: 90.r,
                  height: 102.r,
                  child: Center(
                    child: SizedBox(
                      width: 40.r,
                      height: 40.r,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              SizedBox(height: 16.r),
              AText(
                model.weather.weatherText,
                style: AppTheme.selectLanguageStyle
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    ),
    if (tip != null && tip.isNotEmpty)
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.r,
          vertical: 16.r,
        ),
        child: AText(
          tip,
          style: AppTheme.googleButtonStyle.copyWith(color: AppTheme.text),
        ),
      ),
  ];
}
