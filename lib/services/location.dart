import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class LocationService {
  static Future<Point<double>> getCoordinates({
    String? location,
    String languageCode = 'en-US',
  }) async {
    if (location == null) {
      final result = await GeolocatorPlatform.instance.getCurrentPosition();
      return Point(result.latitude, result.longitude);
    } else {
      final result = await Nominatim.searchByName(
        query: location,
        limit: 1,
        language: languageCode,
      );
      print(result.length);
      return Point(result.first.lat, result.first.lon);
    }
  }

  static Future<Map<String, dynamic>?> fetchAddress(String languageCode) async {
    final Place result;

    try {
      final location = await getCoordinates();

      result = await Nominatim.reverseSearch(
        lat: location.x,
        lon: location.y,
        language: languageCode,
      );
    } catch (exception) {
      debugPrint('Failed while fetching address: $exception');
      rethrow;
    }

    return result.address;
  }

  static Future<String?> fetchCityState(String languageCode) async {
    final address = await fetchAddress(languageCode);
    if (address != null) {
      return '${address['city']}, ${address['state']}';
    }
    return null;
  }
}
