// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'weather.freezed.dart';
//
// @freezed
// class Weather with _$Weather {
//   factory Weather({
//     /// In Celsius
//     @Default(0) int temperature,
//     @Default(0) int maxTemp,
//     @Default(0) int minTemp,
//
//     /// In %
//     @Default(0) int humidity,
//
//     /// In km/hr
//     @Default(0) int wind,
//
//     /// In millibar
//     @Default(0) int pressure,
//     String? weatherIcon,
//     @Default('') String weatherText,
//     @Default({}) Map<String, String> dailyTip,
//     required DateTime date,
//
//     /// In %
//     int? probabilityOfPrecipitation,
//   }) = _Weather;
// }

class Weather {
  int temperature;
  int maxTemp;
  int minTemp;
  int humidity;
  int wind;
  int pressure;
  String? weatherIcon;
  String weatherText;
  Map<String, String> dailyTip;
  DateTime date;
  int? probabilityOfPrecipitation;

  // Constructor
  Weather({
    this.temperature = 0,
    this.maxTemp = 0,
    this.minTemp = 0,
    this.humidity = 0,
    this.wind = 0,
    this.pressure = 0,
    this.weatherIcon,
    this.weatherText = '',
    this.dailyTip = const {},
    required this.date,
    this.probabilityOfPrecipitation,
  });

  // Factory method to create a Weather instance from a Map
  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      temperature: map['temperature'] ?? 0,
      maxTemp: map['maxTemp'] ?? 0,
      minTemp: map['minTemp'] ?? 0,
      humidity: map['humidity'] ?? 0,
      wind: map['wind'] ?? 0,
      pressure: map['pressure'] ?? 0,
      weatherIcon: map['weatherIcon'],
      weatherText: map['weatherText'] ?? '',
      dailyTip: Map<String, String>.from(map['dailyTip'] ?? {}),
      date: DateTime.parse(map['date']),
      probabilityOfPrecipitation: map['probabilityOfPrecipitation'],
    );
  }

  // Method to convert Weather instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'humidity': humidity,
      'wind': wind,
      'pressure': pressure,
      'weatherIcon': weatherIcon,
      'weatherText': weatherText,
      'dailyTip': dailyTip,
      'date': date.toIso8601String(),
      'probabilityOfPrecipitation': probabilityOfPrecipitation,
    };
  }
}
