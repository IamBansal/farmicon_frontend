import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmicon/models/crop_analysis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_localizations.dart';
import '../config/environment_config.dart';
import '../constants/enums/view_state.dart';
import '../models/address.dart';
import '../models/crop_price.dart';
import '../models/scheme_info.dart';
import '../models/user.dart';
import '../models/vendor_data.dart';
import '../models/weather.dart';
import '../services/api.dart';
import '../services/location.dart';
import '../services/weather.dart';
import '../ui/views/home/home_tab/tab.dart';
import '../ui/views/home/profile_tab/tab.dart';
import '../utils/user_to_json.dart';
import 'language_selection.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends LanguageSelectionViewModel {
  // Data
  Map<String, String> imageUrlMap = {};
  Map<String, Map<String, String>> textsMap = {};

  String _locationText = 'Getting location...';

  String get locationText => _locationText;

  set locationText(String newState) {
    _locationText = newState;
    notifyListeners();
  }

  Weather weather = Weather(date: DateTime.now());
  List<Weather> forecast = [];

  CropAnalysis analysis = CropAnalysis(image: '', disease: '', plant_name: '', treatment: '');

  Future<void> sendPhotoForAnalysis(String imageFile, String plantName) async {
    String apiUrl = 'http://3.110.178.72:8001/predict';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['plant_type'] = plantName;
    var file = await http.MultipartFile.fromPath('image', imageFile);
    request.files.add(file);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> responseMap = json.decode(responseBody);
        doctorResults.add(CropAnalysis.fromMap(responseMap));
        notifyListeners();
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  List<SchemeInfo> govSchemes = <SchemeInfo>[], orgFarmingTips = <SchemeInfo>[];

  List<VendorData> warehouses = <VendorData>[],
      droneCenters = <VendorData>[],
      insuranceCenters = <VendorData>[],
      soilTestingCenters = <VendorData>[];

  List<CropAnalysis> doctorResults = [];

  List<CropPrice>? allCrops, pricesToShow, cropsToShow;

  int _tabIndex = 0;
  String id = '';

  int get tabIndex => _tabIndex;

  void setTabIndex(int newState) {
    _tabIndex = newState;
    notifyListeners();
  }

  String _homeTabRoute = HomeTabRoutes.home;

  String get homeTabRoute => _homeTabRoute;

  set homeTabRoute(String newState) {
    _homeTabRoute = newState;
    notifyListeners();
  }

  String _profileTabRoute = ProfileTabRoutes.profile;

  String get profileTabRoute => _profileTabRoute;

  set profileTabRoute(String newState) {
    _profileTabRoute = newState;
    notifyListeners();
  }

  late User _user;
  User get user => _user;

  set user(User? newState) {
    _user = newState ?? _user;
    _syncUserWithFirebase();
    notifyListeners();
  }

  void updateArea([String? areaUnit]) {
    final newAreaQuantity =
        areaQuantity.text.replaceAll(',', '').replaceAll(' ', '');
    if (double.tryParse(newAreaQuantity) != null) {
     _user.areaQuantity = double.parse(newAreaQuantity);
     user = _user;
    }
    if (areaUnit != null) {
      _user.areaUnit = areaUnit;
      user = _user;
      // user = _user.copyWith(areaUnit: areaUnit);
    }

    debugPrint('${user.areaQuantity} ${user.areaUnit}');

    notifyListeners();
  }

  void toggleCrop(String name, String variety) {
    debugPrint('Toggling crop $name');

    var indexAmongstUserCrops = _user.cropsEn.indexOf("$name,$variety");
    final indexAmongstAllCrops = allCrops!.indexWhere(
      (element) =>
          element.name['en'] == name && element.variety['en'] == variety,
    );
    final crop = allCrops!.removeAt(indexAmongstAllCrops);

    if (indexAmongstUserCrops == -1) {
      _user.cropsEn.add("$name,$variety");
      _user.cropsHi.add("${crop.name['hi']},${crop.variety['hi']}");
    } else {
      _user.cropsEn.removeAt(indexAmongstUserCrops);
      _user.cropsHi.removeAt(indexAmongstUserCrops);
    }


    crop.isBookmarked = !crop.isBookmarked;
    allCrops!.insert(
      indexAmongstAllCrops,
      crop
    );
    cropsToShow = allCrops;
    pricesToShow = allCrops;

    sortCrops();

    _syncUserWithFirebase();

    notifyListeners();
  }

  void _syncUserWithFirebase() async {
    final QuerySnapshot result;
    result = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: id)
        .get();
    final docId = result.docs[0].id;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .set(userToJson(_user));
  }

  late TextEditingController areaQuantity,
      pincode,
      district,
      city,
      streetName,
      forecastLocation;

  void updateAddress() {
    if (int.tryParse(pincode.text) != null) {
      _user.address.pincode = int.tryParse(pincode.text)!;
    }
    if (streetName.text.isNotEmpty) {
      _user.address.streetName = streetName.text;
      // user = _user.copyWith.address(streetName: streetName.text);
    }
    if (district.text.isNotEmpty) {
      _user.address.district = district.text;
      // user = _user.copyWith.address(district: district.text);
    }
    if (city.text.isNotEmpty) {
      _user.address.city = city.text;
      // user = _user.copyWith.address(city: city.text);
    }
    user = _user;

    debugPrint(_user.address.toString());

    notifyListeners();
  }

  void filterCrops(String query) {
    debugPrint('filtering based on the query "$query"');

    if (query.isEmpty) {
      pricesToShow = allCrops;
    } else {
      pricesToShow = allCrops
          ?.where(
            (element) =>
                element.name['en']!.toLowerCase().contains(query) ||
                element.name['hi']!.contains(query),
          )
          .toList();
    }
    notifyListeners();
  }

  void shortListCrops(String query) {
    debugPrint('shortlisting based on the query "$query"');

    if (query.isEmpty) {
      cropsToShow = allCrops;
    } else {
      cropsToShow = allCrops
          ?.where(
            (element) =>
                element.name['en']!.toLowerCase().contains(query) ||
                element.name['hi']!.contains(query),
          )
          .toList();
    }
    notifyListeners();
  }

  void sortCrops() {
    allCrops?.sort((cropA, cropB) {
      // First compare using bookmarking
      if (cropA.isBookmarked != cropB.isBookmarked) {
        return cropB.isBookmarked ? 1 : -1;
      } else {
        // Tie break using name
        return cropA.name['en']!.compareTo(cropB.name['en']!);
      }
    });
    cropsToShow?.sort((cropA, cropB) {
      // First compare using bookmarking
      if (cropA.isBookmarked != cropB.isBookmarked) {
        return cropB.isBookmarked ? 1 : -1;
      } else {
        // Tie break using name
        return cropA.name['en']!.compareTo(cropB.name['en']!);
      }
    });
    pricesToShow?.sort((cropA, cropB) {
      // First compare using bookmarking
      if (cropA.isBookmarked != cropB.isBookmarked) {
        return cropB.isBookmarked ? 1 : -1;
      } else {
        // Tie break using name
        return cropA.name['en']!.compareTo(cropB.name['en']!);
      }
    });
  }

  void useCurrentLocation() async {
    debugPrint('fetching current address');

    final reverseGeocodedAddress = await LocationService.fetchAddress('en');

    if (reverseGeocodedAddress != null) {
      _user.address.streetName = reverseGeocodedAddress['street'] ?? '';
      _user.address.city= reverseGeocodedAddress['city'] ?? '';
      _user.address.district= reverseGeocodedAddress['district'] ?? '';
      _user.address.pincode= int.tryParse(reverseGeocodedAddress['postcode']) ?? 0;

      user = _user;
      streetName.text = _user.address.streetName;
      pincode.text = _user.address.pincode.toString();
      city.text = _user.address.city;
      district.text = _user.address.district;

      debugPrint(_user.address.toString());

      notifyListeners();
    } else {
      Get.rawSnackbar(message: AppLocalization.of(Get.context!).getTranslatedValue('couldntFetchLocationText').toString());
    }
  }

  void fetchDetailedWeather({bool rebuild = false}) async {
    forecast = [];
    if (rebuild) notifyListeners();

    debugPrint("Fetching today's weather for ${forecastLocation.text}");
    final todayWeather = await WeatherService.getCurrentWeather(
      languageCode,
      location: forecastLocation.text,
    );

    debugPrint('Fetching 15 day forecast');
    final forecast15 = await WeatherService.getFreeForecast(
      languageCode: languageCode,
      location: forecastLocation.text,
    );

    forecast = forecast15..insert(0, todayWeather);
    setState(ViewState.idle);
  }

  // Initializers
  void onModelReady() async {
    await _loadUid().whenComplete(() async => await fetchAndSyncUser());

    initControllers();
    fetchLocationData();
    fetchWeather();
    fetchGovSchemes();
    fetchOrgFarmingTips();
    fetchImageUrlMap();
    fetchTextMap();
    fetchCropPrices();
    notifyListeners();
  }

  Future<void> _loadUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('uid') ?? "";
    notifyListeners();
  }

  Future<void> fetchAndSyncUser() async {
    QueryDocumentSnapshot dbUser;

    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: id)
        .get();
    dbUser = result.docs[0];
    _user = User(
      phoneNumber: dbUser.get('phone_number') ?? '',
      email: dbUser.get('email') ?? '',
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
      name: dbUser.get('name') ?? '',
      cropsEn: List<String>.from(dbUser.get('crops-en') ?? []),
      cropsHi: List<String>.from(dbUser.get('crops-hi') ?? []),
      address: Address(
        streetName: dbUser.get('address')['street_name'] ?? '',
        city: dbUser.get('address')['city'] ?? '',
        district: dbUser.get('address')['district'] ?? '',
        pincode: (dbUser.get('address')['pincode'] as int),
      ),
    );
    notifyListeners();
    debugPrint('User is initialized');
  }

  void initControllers() {
    if (_user.areaQuantity != 0.0) {
      areaQuantity = TextEditingController(text: _user.areaQuantity.toString());
    } else {
      areaQuantity = TextEditingController();
    }
    district = TextEditingController(text: _user.address.district);
    streetName = TextEditingController(text: _user.address.streetName);
    city = TextEditingController(text: _user.address.city);
    forecastLocation = TextEditingController();
    if (_user.address.pincode != 0) {
      pincode = TextEditingController(text: _user.address.pincode.toString());
    } else {
      pincode = TextEditingController();
    }
  }

  void fetchLocationData() async {
    final response = await LocationService.fetchCityState(languageCode);
    if (response != null) {
      _locationText = response;
      forecastLocation = TextEditingController(text: response);
    }
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  void fetchWeather() async {
    weather = await WeatherService.updateCurrentWeather(weather, languageCode);
    notifyListeners();
  }


  void fetchWarehouses() async {
    try {
      debugPrint('fetching warehouses');
      final result = await ApiService.client.get(
        'warehouses',
        queryParameters: {"populate": "*"},
      );
      print(result.data);

      warehouses = !result.data.isNull ? vendorDataListFromJsonList(result.data) : warehouses;
      notifyListeners();
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching warehouses");
      debugPrint('Failed while fetching warehouses: $exception');
    }
  }

  void fetchDroneCenters() async {
    try {
      debugPrint('fetching drone centers');
      final result = await ApiService.client.get(
        'drones',
        queryParameters: {"populate": "*"},
      );
      droneCenters = vendorDataListFromJsonList(result.data!);
      notifyListeners();
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching drone centers");
      debugPrint('Failed while fetching drones: $exception');
    }
  }

  void fetchInsuranceCenters() async {
    try {
      debugPrint('fetching insurance centers');
      final result = await ApiService.client.get(
        'crop-insurances-centers', // Yes the typo is intentional
        queryParameters: {"populate": "*"},
      );
      insuranceCenters = vendorDataListFromJsonList(result.data!);
      notifyListeners();
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching insurance centers");
      debugPrint('Failed while fetching insurance: $exception');
    }
  }

  void fetchSoilTestingCenters() async {
    try {
      debugPrint('fetching soil testing centers');
      final result = await ApiService.client.get(
        'soil-testing-centers',
        queryParameters: {"populate": "*"},
      );
      soilTestingCenters = vendorDataListFromJsonList(result.data!);
      notifyListeners();
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching soil testing centers");
      debugPrint('Failed while fetching soil testing: $exception');
    }
  }

  void fetchDoctorResultsCenters() async {
    try {
      debugPrint('fetching crop doctor results');
      final result = await ApiService.client.get(
        'crop-doctor-results',
        queryParameters: {
          "populate": "*",
          // "sort[0]": "date_time:desc",
          // "sort[1]": ""
        },
      );
      // doctorResults = doctorResultListFromJsonList(result.data!);
      notifyListeners();
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching crop doctor results");
      debugPrint('Failed while fetching doctor results: $exception');
      rethrow;
    }
  }

  void fetchGovSchemes() async {
    try {
      debugPrint('fetching government schemes');
      final result = await ApiService.client.get(
        'gov-schemes',
        queryParameters: {"populate": "*"},
      );
      govSchemes = schemeInfoListFromJsonList(result.data!);
      notifyListeners();
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching government schemes");
      debugPrint('Failed while fetching schemes: $exception');
    }
  }

  void fetchOrgFarmingTips() async {
    try {
      debugPrint('fetching organic farming tips');
      final result = await ApiService.client.get(
        'organic-farming-tips',
        queryParameters: {"populate": "*"},
      );
      orgFarmingTips = schemeInfoListFromJsonList(result.data!);
      notifyListeners();
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching organic farming tips");
      debugPrint('Failed while fetching org tips: $exception');
    }
  }

  void fetchCropPrices({String? pincode}) async {
    try {
      debugPrint('fetching crop prices');

      final result = await ApiService.client.get(
        'supported-crops',
        queryParameters: {"populate": "*"},
      );
      final cropNames = result.data!;

      if (pincode == null || pincode == '0') {
        pincode = _user.address.pincode.toString();
      }

      final prices = await ApiService.getPrices(
        pincode,
        user.address.district,
      );

      if (prices['status_code'] != 200 || prices['data'] == 'null') {
        throw Exception();
      }

      allCrops = [];

      for (Map<String, dynamic> crop in cropNames) {
        var found = false;
        for (Map<String, dynamic> price in prices['data']['message']) {
          if (crop['attributes']['en'] == price['commodity']) {
            allCrops!.add(CropPrice(
              name: {
                "en": crop["attributes"]["en"],
                "hi": crop["attributes"]["hi"],
              },
              unitShort: {'en': 'Quin', 'hi': 'क्विं'},
              unit: {'en': 'Quintal', 'hi': 'क्विंटल'},
              price: double.tryParse(price['modal_price']) ??
                  (double.tryParse(price['max_price']) ??
                      (double.tryParse(price['min_price']) ?? 0)),
              isBookmarked: user.cropsEn
                  .contains("${crop["attributes"]["en"]},${price['variety']}"),
              variety: {'en': price['variety'], 'hi': price['variety']},
            ));
            found = true;
          }
        }

        if (!found) {
          allCrops!.add(CropPrice(
            name: {
              "en": crop["attributes"]["en"],
              "hi": crop["attributes"]["hi"],
            },
            unitShort: {'en': 'Quin', 'hi': 'क्विं'},
            unit: {'en': 'Quintal', 'hi': 'क्विंटल'},
            price: 0,
            isBookmarked:
            user.cropsEn.contains("${crop["attributes"]["en"]},Other"),
            variety: {'en': 'Other', 'hi': 'Other'},
          ));
        }
      }

      pricesToShow = allCrops;
      cropsToShow = allCrops;
      sortCrops();

      notifyListeners();
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching crop prices");
      debugPrint('Failed while fetching crop prices: $exception');
      rethrow;
    }
  }

  void fetchImageUrlMap() async {
    debugPrint('fetching image url map');
    try {
      final result = await ApiService.client.get('image-urls');

      for (var map in result.data!) {
        imageUrlMap[map['attributes']['slug']] =
            (map['attributes']['image_url'] as String).replaceAll(
              'BASE_URL',
              ENV.BASE_URL,
            );
      }
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching image urls");
      debugPrint('Failed while fetching image urls: $exception');
    }
  }

  void fetchTextMap() async {
    debugPrint('fetching texts map');
    try {
      final result = await ApiService.client.get('texts');

      for (var map in result.data) {
        textsMap[map['attributes']['slug']] = {
          'hi': map['attributes']['hi'] as String,
          'en': map['attributes']['en'] as String,
        };
      }
    } catch (exception) {
      setState(ViewState.error);
      setErrorMessage("Failed while fetching texts");
      debugPrint('Failed while fetching text map: $exception');
    }
  }


  // void fetchWarehouses() async {
  //   try {
  //     debugPrint('fetching warehouses');
  //     final result = await ApiService.client.collection.get(
  //       'warehouses',
  //       queryParameters: {"populate": "*"},
  //     );
  //     warehouses = vendorDataListFromJsonList(result.item1!);
  //     notifyListeners();
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching warehouses");
  //     debugPrint('Failed while fetching warehouses: $exception');
  //   }
  // }
  //
  // void fetchDroneCenters() async {
  //   try {
  //     debugPrint('fetching drone centers');
  //     final result = await ApiService.client.collection.get(
  //       'drones',
  //       queryParameters: {"populate": "*"},
  //     );
  //     droneCenters = vendorDataListFromJsonList(result.item1!);
  //     notifyListeners();
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching drone centers");
  //     debugPrint('Failed while fetching drones: $exception');
  //   }
  // }
  //
  // void fetchInsuranceCenters() async {
  //   try {
  //     debugPrint('fetching insurance centers');
  //     final result = await ApiService.client.collection.get(
  //       'crop-insurances-centers', // Yes the typo is intentional
  //       queryParameters: {"populate": "*"},
  //     );
  //     insuranceCenters = vendorDataListFromJsonList(result.item1!);
  //     notifyListeners();
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching insurance centers");
  //     debugPrint('Failed while fetching insurance: $exception');
  //   }
  // }
  //
  // void fetchSoilTestingCenters() async {
  //   try {
  //     debugPrint('fetching soil testing centers');
  //     final result = await ApiService.client.collection.get(
  //       'soil-testing-centers',
  //       queryParameters: {"populate": "*"},
  //     );
  //     soilTestingCenters = vendorDataListFromJsonList(result.item1!);
  //     notifyListeners();
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching soil testing centers");
  //     debugPrint('Failed while fetching soil testing: $exception');
  //   }
  // }
  //
  // void fetchDoctorResultsCenters() async {
  //   try {
  //     debugPrint('fetching crop doctor results');
  //     final result = await ApiService.client.collection.get(
  //       'crop-doctor-results',
  //       queryParameters: {
  //         "populate": "*",
  //         // "sort[0]": "date_time:desc",
  //         // "sort[1]": ""
  //       },
  //     );
  //     doctorResults = doctorResultListFromJsonList(result.item1!);
  //     notifyListeners();
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching crop doctor results");
  //     debugPrint('Failed while fetching doctor results: $exception');
  //     rethrow;
  //   }
  // }
  //
  // void fetchGovSchemes() async {
  //   try {
  //     debugPrint('fetching government schemes');
  //     final result = await ApiService.client.collection.get(
  //       'gov-schemes',
  //       queryParameters: {"populate": "*"},
  //     );
  //     govSchemes = schemeInfoListFromJsonList(result.item1!);
  //     notifyListeners();
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching government schemes");
  //     debugPrint('Failed while fetching schemes: $exception');
  //   }
  // }
  //
  // void fetchOrgFarmingTips() async {
  //   try {
  //     debugPrint('fetching organic farming tips');
  //     final result = await ApiService.client.collection.get(
  //       'organic-farming-tips',
  //       queryParameters: {"populate": "*"},
  //     );
  //     orgFarmingTips = schemeInfoListFromJsonList(result.item1!);
  //     notifyListeners();
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching organic farming tips");
  //     debugPrint('Failed while fetching org tips: $exception');
  //   }
  // }
  //
  // void fetchCropPrices({String? pincode}) async {
  //   try {
  //     debugPrint('fetching crop prices');
  //
  //     final result = await ApiService.client.collection.get(
  //       'supported-crops',
  //       queryParameters: {"populate": "*"},
  //     );
  //     final cropNames = result.item1!;
  //
  //     if (pincode == null || pincode == '0') {
  //       pincode = _user.address.pincode.toString();
  //     }
  //
  //     final prices = await ApiService.getPrices(
  //       pincode,
  //       user.address.district,
  //     );
  //
  //     if (prices['status_code'] != 200 || prices['data'] == 'null') {
  //       throw Exception();
  //     }
  //
  //     allCrops = [];
  //
  //     for (Map<String, dynamic> crop in cropNames) {
  //       var found = false;
  //       for (Map<String, dynamic> price in prices['data']['message']) {
  //         if (crop['attributes']['en'] == price['commodity']) {
  //           allCrops!.add(CropPrice(
  //             name: {
  //               "en": crop["attributes"]["en"],
  //               "hi": crop["attributes"]["hi"],
  //             },
  //             unitShort: {'en': 'Quin', 'hi': 'क्विं'},
  //             unit: {'en': 'Quintal', 'hi': 'क्विंटल'},
  //             price: double.tryParse(price['modal_price']) ??
  //                 (double.tryParse(price['max_price']) ??
  //                     (double.tryParse(price['min_price']) ?? 0)),
  //             isBookmarked: user.cropsEn
  //                 .contains("${crop["attributes"]["en"]},${price['variety']}"),
  //             variety: {'en': price['variety'], 'hi': price['variety']},
  //           ));
  //           found = true;
  //         }
  //       }
  //
  //       if (!found) {
  //         allCrops!.add(CropPrice(
  //           name: {
  //             "en": crop["attributes"]["en"],
  //             "hi": crop["attributes"]["hi"],
  //           },
  //           unitShort: {'en': 'Quin', 'hi': 'क्विं'},
  //           unit: {'en': 'Quintal', 'hi': 'क्विंटल'},
  //           price: 0,
  //           isBookmarked:
  //               user.cropsEn.contains("${crop["attributes"]["en"]},Other"),
  //           variety: {'en': 'Other', 'hi': 'Other'},
  //         ));
  //       }
  //     }
  //
  //     pricesToShow = allCrops;
  //     cropsToShow = allCrops;
  //     sortCrops();
  //
  //     notifyListeners();
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching crop prices");
  //     debugPrint('Failed while fetching crop prices: $exception');
  //     rethrow;
  //   }
  // }
  //
  // void fetchImageUrlMap() async {
  //   debugPrint('fetching image url map');
  //   try {
  //     final result = await ApiService.client.collection.get('image-urls');
  //
  //     for (var map in result.item1!) {
  //       imageUrlMap[map['attributes']['slug']] =
  //           (map['attributes']['image_url'] as String).replaceAll(
  //         'BASE_URL',
  //         ENV.BASE_URL,
  //       );
  //     }
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching image urls");
  //     debugPrint('Failed while fetching image urls: $exception');
  //   }
  // }
  //
  // void fetchTextMap() async {
  //   debugPrint('fetching texts map');
  //   try {
  //     final result = await ApiService.client.collection.get('texts');
  //
  //     for (var map in result.item1!) {
  //       textsMap[map['attributes']['slug']] = {
  //         'hi': map['attributes']['hi'] as String,
  //         'en': map['attributes']['en'] as String,
  //       };
  //     }
  //   } catch (exception) {
  //     setState(ViewState.error);
  //     setErrorMessage("Failed while fetching texts");
  //     debugPrint('Failed while fetching text map: $exception');
  //   }
  // }
}
