import 'package:flutter/foundation.dart';
import 'package:weather/weather.dart' as nom;
import '../config/environment_config.dart';
import '../constants/app_assets.dart';
import '../models/weather.dart';
import 'api.dart';
import 'location.dart';
import 'package:solar_calculator/solar_calculator.dart';

class WeatherService {
  static Future<Weather> updateCurrentWeather(
    Weather weather,
    String languageCode,
  ) async {
    debugPrint('FETCHING WEATHER');
    final coordinates =
        await LocationService.getCoordinates(languageCode: languageCode);

    final result = await nom.WeatherFactory(
      ENV.OPEN_WEATHER_API_KEY,
      language:
          languageCode == 'en' ? nom.Language.ENGLISH : nom.Language.HINDI,
    ).currentWeatherByLocation(coordinates.x, coordinates.y);

    return Weather(
      temperature: result.temperature?.celsius?.round() ?? weather.temperature,
      humidity: result.humidity?.round() ?? weather.humidity,
      weatherText: result.weatherDescription ?? weather.weatherText,
      date: DateTime.now(),
      weatherIcon: await getWeatherIcon(
        result.weatherMain!,
        result.weatherDescription!,
        sunrise: result.sunrise,
        sunset: result.sunset,
      ),
      dailyTip: await getTip(result.weatherDescription),
    );
  }

  static Future<Weather> getCurrentWeather(
    String languageCode, {
    String? location,
  }) async {
    final coordinates = await LocationService.getCoordinates(
      location: location,
      languageCode: languageCode,
    );
    final result = await nom.WeatherFactory(
      ENV.OPEN_WEATHER_API_KEY,
      language:
          languageCode == 'en' ? nom.Language.ENGLISH : nom.Language.HINDI,
    ).currentWeatherByLocation(coordinates.x, coordinates.y);

    return Weather(
      temperature: result.temperature?.celsius?.round() ?? 0,
      humidity: result.humidity?.round() ?? 0,
      weatherText: result.weatherDescription ?? '',
      maxTemp: result.tempMax?.celsius?.round() ?? 0,
      minTemp: result.tempMin?.celsius?.round() ?? 0,
      pressure: (result.pressure ?? 0) ~/ 100,
      wind: ((result.windSpeed ?? 0) * 5) ~/ 18,
      weatherIcon: await getWeatherIcon(
        result.weatherMain!,
        result.weatherDescription!,
        sunrise: result.sunrise,
        sunset: result.sunset,
        languageCode: languageCode,
        location: location,
      ),
      date: DateTime.now(),
      dailyTip: await getTip(result.weatherDescription),
    );
  }

  // TODO: This Method Is DEBUG Only
  static Future<List<Weather>> getFreeForecast({
    required String languageCode,
    String? location,
  }) async {
    final coordinates = await LocationService.getCoordinates(
      location: location,
      languageCode: languageCode,
    );

    final result = await ApiService.getForecast5(
      coordinates.x,
      coordinates.y,
      languageCode,
    );

    List<Weather> forecast = [];

    for (Map<String, dynamic> map in result['data']['list']) {
      forecast.add(Weather(
        date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
        temperature: ((map['main']['temp'] as num?)?.round() ?? 273) - 273,
        maxTemp: ((map['main']['temp_max'] as num?)?.round() ?? 273) - 273,
        minTemp: ((map['main']['temp_min'] as num?)?.round() ?? 273) - 273,
        humidity: (map['main']['humidity'] as num?)?.round() ?? 0,
        pressure: ((map['main']['pressure'] as num?) ?? 0) ~/ 100,
        probabilityOfPrecipitation: ((map['pop'] ?? 0) * 100).round(),
        wind: (((map['wind']['speed'] as num?) ?? 0) * 5) ~/ 18,
        weatherText: map['weather'][0]['description'] ?? '',
        weatherIcon: await getWeatherIcon(
          map['weather'][0]['main']!,
          map['weather'][0]['description']!,
          dayOverride: true,
        ),
      ));
    }

    return forecast;
  }

  static Future<List<Weather>> getForecast15(
    String languageCode, {
    String? location,
  }) async {
    final coordinates = await LocationService.getCoordinates(
      location: location,
      languageCode: languageCode,
    );
    final result = await ApiService.getForecast15(
      coordinates.x,
      coordinates.y,
      languageCode,
    );

    List<Weather> forecast = [];

    for (Map<String, dynamic> map in result['data']['list']) {
      forecast.add(await weatherFromMap(map));
    }

    return forecast;
  }

  static Future<Weather> weatherFromMap(Map<String, dynamic> map) async {
    return Weather(
      date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
      temperature: ((map['temp']['day'] as num?)?.round() ?? 273) - 273,
      maxTemp: ((map['temp']['max'] as num?)?.round() ?? 273) - 273,
      minTemp: ((map['temp']['min'] as num?)?.round() ?? 273) - 273,
      humidity: (map['humidity'] as num?)?.round() ?? 0,
      pressure: ((map['pressure'] as num?) ?? 0) ~/ 100,
      probabilityOfPrecipitation: ((map['pop'] ?? 0) * 100).round(),
      wind: (((map['speed'] as num?) ?? 0) * 5) ~/ 18,
      weatherText: map['weather']['description'] ?? '',
      weatherIcon: await getWeatherIcon(
        map['weather']['main']!,
        map['weather']['description']!,
        dayOverride: true,
      ),
    );
  }

  static Future<String> getWeatherIcon(
    String main,
    String description, {
    DateTime? sunrise,
    DateTime? sunset,
    String? languageCode,
    String? location,
    bool dayOverride = false,
  }) async {
    switch (main) {
      case 'Tornado':
        return AppAssets.tornado;
      case 'Snow':
        return AppAssets.snow;
      case 'Rain':
      case 'Drizzle':
        return AppAssets.rain;
      case 'Thunderstorm':
        return AppAssets.lightning;
    }

    if (!dayOverride && (sunrise == null || sunset == null)) {
      final coordinates = await LocationService.getCoordinates(
        location: location,
        languageCode: languageCode!,
      );
      final instant = Instant(year: DateTime.now().year, month: DateTime.now().month, day: DateTime.now().day, hour: DateTime.now().hour, timeZoneOffset: 2.0);
      final calc = SolarCalculator(instant, coordinates.x, coordinates.y);
      sunrise = DateTime(calc.sunriseTime.year, calc.sunriseTime.month, calc.sunriseTime.day, calc.sunriseTime.hour, calc.sunriseTime.minute,);
      sunset = DateTime(calc.sunsetTime.year, calc.sunsetTime.month, calc.sunsetTime.day, calc.sunsetTime.hour, calc.sunsetTime.minute,);
    }

    if (dayOverride ||
        ((sunrise?.isBefore(DateTime.now()) ?? true) &&
            (sunset?.isAfter(DateTime.now()) ?? true))) {
      // Day
      if (main == 'Clear') {
        return AppAssets.clearDay;
      }
      if ((description == 'few clouds') ||
          (description == 'scattered clouds')) {
        return AppAssets.someCloudsDay;
      }
      if ((description == 'broken clouds') ||
          (description == 'overcast clouds')) {
        return AppAssets.cloudyDay;
      }
      return AppAssets.clearDay;
    } else {
      // Night
      if (main == 'Clear') {
        return AppAssets.clearNight;
      }
      if ((description == 'few clouds') ||
          (description == 'scattered clouds')) {
        return AppAssets.someCloudsNight;
      }
      if ((description == 'broken clouds') ||
          (description == 'overcast clouds')) {
        return AppAssets.cloudyNight;
      }
      return AppAssets.clearNight;
    }
  }

  static Future<Map<String, String>> getTip(String? weatherDescription) async {
    try {
      final result1 = await ApiService.client.get(
        'tips',
        queryParameters: {
          "filters[weather_desc][\$eq]": weatherDescription,
        },
      );
      debugPrint('fetched tips for current weather! ${result1.data}');
      // return {
      //   'hi': (result1.data![0]['attributes']['hi'] as String),
      //   'en': (result1.data![0]['attributes']['en'] as String),
      // };
      return {'hi': '', 'en': ''};
    } catch (e) {
      return {'hi': '', 'en': ''};
    }
  }
}
