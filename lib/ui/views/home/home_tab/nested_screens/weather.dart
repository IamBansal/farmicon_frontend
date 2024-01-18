part of '../tab.dart';

class WeatherSubpage extends StatelessWidget {
  WeatherSubpage({required HomeViewModel model, Key? key}) : super(key: key) {
    model.fetchDetailedWeather();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSearchBar(HomeViewModel model) {
      return TextFormField(
        controller: model.forecastLocation,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 14.r),
          hintText: AppLocalization.of(context).getTranslatedValue('location').toString(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          suffixIcon: GestureDetector(
            onTap: () => model.fetchDetailedWeather(rebuild: true),
            child: Icon(Icons.navigate_next, size: 24.r),
          ),
        ),
        onEditingComplete: () => model.fetchDetailedWeather(rebuild: true),
      );
    }

    Widget buildTodayForecast(Weather weather) {
      return Material(
        elevation: 5,
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(8.r),
        color: AppTheme.dirtyWhite,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AText(
                        AppLocalization.of(context).getTranslatedValue('today').toString(),
                        style: AppTheme.googleButtonStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      SizedBox(height: 16.r),
                      Row(
                        children: [
                          AText(
                            weather.temperature.toString(),
                            style:
                                AppTheme.h0.copyWith(color: AppTheme.tertiary),
                          ),
                          AText(
                            ' °C',
                            style: AppTheme.h0.copyWith(
                              color: AppTheme.tertiary,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.r),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 12.r),
                          AText(
                            'min ${weather.minTemp}°C',
                            style: AppTheme.minMaxTempStyle,
                          ),
                          SizedBox(width: 16.r),
                          AText(
                            'max ${weather.maxTemp}°C',
                            style: AppTheme.minMaxTempStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (weather.weatherIcon != null)
                        SvgPicture.asset(
                          weather.weatherIcon!,
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
                        weather.weatherText,
                        style: AppTheme.selectLanguageStyle
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.r),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 10.sw / 1.sh,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset(
                        AppAssets.wind,
                        width: 24.r,
                      ),
                      SizedBox(width: 2.r),
                      AText(
                        '${AppLocalization.of(context).getTranslatedValue('wind').toString()} - ${weather.wind} km/hr',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset(
                        AppAssets.blueDrop,
                        width: 24.r,
                      ),
                      SizedBox(width: 2.r),
                      AText(
                        '${AppLocalization.of(context).getTranslatedValue('humidity').toString()} - ${weather.humidity}%',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset(
                        AppAssets.pressure,
                        width: 24.r,
                      ),
                      SizedBox(width: 2.r),
                      AText(
                        '${AppLocalization.of(context).getTranslatedValue('pressure').toString()} - ${weather.pressure} mbar',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget buildTipSection(Weather weather) {
      final tip = weather.dailyTip[AppLocalization.of(context).locale.toString()];
      if (tip != null && tip.isNotEmpty) {
        return Material(
          elevation: 5,
          type: MaterialType.card,
          borderRadius: BorderRadius.circular(8.r),
          color: AppTheme.lightPrimary,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AText(
                  AppLocalization.of(context).getTranslatedValue('proTip').toString(),
                  style: AppTheme.vendorDataTitleStyle
                      .copyWith(color: AppTheme.tertiary),
                ),
                SizedBox(height: 8.r),
                AText(
                  tip,
                  style: AppTheme.otpInstructionsStyle
                      .copyWith(color: AppTheme.grey100),
                ),
              ],
            ),
          ),
        );
      }

      return Container();
    }

    Widget buildFortnightForecast(List<Weather> forecast) {
      Widget buildOneRow(int i) {
        return Padding(
          padding: EdgeInsets.only(bottom: 13.r),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AText(
                    (i == 0)
                        ? AppLocalization.of(context).getTranslatedValue('tomorrow').toString()
                        : forecast[i].date.toString(),
                    style: AppTheme.otpInstructionsStyle
                        .copyWith(color: AppTheme.grey100),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        forecast[i].weatherIcon!,
                        width: 16.r,
                      ),
                      SizedBox(width: 2.r),
                      AText(
                        ' ${forecast[i].probabilityOfPrecipitation}% rain',
                        style: AppTheme.otpInstructionsStyle
                            .copyWith(color: AppTheme.grey100),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AText(
                    '${forecast[i].minTemp}°C'
                    ' / '
                    '${forecast[i].maxTemp}°C',
                    style: AppTheme.otpInstructionsStyle
                        .copyWith(color: AppTheme.grey100),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Material(
        elevation: 5,
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(8.r),
        color: AppTheme.dirtyWhite,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 0),
          child: (forecast.isNotEmpty)
              ? Column(
                  children: List.generate(forecast.length, buildOneRow,
                      growable: true)
                    ..insert(
                      0,
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 7.r),
                        child: AText(
                          AppLocalization.of(context).getTranslatedValue('forecast15').toString(),
                          style: AppTheme.googleButtonStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                )
              : Center(
                  child: AText(AppLocalization.of(context).getTranslatedValue('couldNotFetchForecast').toString()),
                ),
        ),
      );
    }

    final model = Provider.of<HomeViewModel>(context, listen: true);

    if (model.forecast.isNotEmpty) {
      return ListView(
        padding: EdgeInsets.all(16.r),
        children: <Widget>[
          buildSearchBar(model),
          SizedBox(height: 11.r),
          buildTodayForecast(model.forecast[0]),
          SizedBox(height: 32.r),
          buildTipSection(model.forecast[0]),
          SizedBox(height: 32.r),
          buildFortnightForecast(model.forecast.sublist(1)),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
