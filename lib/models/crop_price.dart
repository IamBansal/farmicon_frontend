// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'crop_price.freezed.dart';
//
// @freezed
// class CropPrice with _$CropPrice {
//   factory CropPrice({
//     required Map<String, String> name,
//     required Map<String, String> unit,
//     required Map<String, String> unitShort,
//     required Map<String, String> variety,
//     required double price,
//     required bool isBookmarked,
//   }) = _CropPrice;
// }


class CropPrice {
  Map<String, String> name;
  Map<String, String> unit;
  Map<String, String> unitShort;
  Map<String, String> variety;
  double price;
  bool isBookmarked;

  // Constructor
  CropPrice({
    required this.name,
    required this.unit,
    required this.unitShort,
    required this.variety,
    required this.price,
    required this.isBookmarked,
  });

  // Factory method to create a CropPrice instance from a Map
  factory CropPrice.fromMap(Map<String, dynamic> map) {
    return CropPrice(
      name: Map<String, String>.from(map['name'] ?? {}),
      unit: Map<String, String>.from(map['unit'] ?? {}),
      unitShort: Map<String, String>.from(map['unitShort'] ?? {}),
      variety: Map<String, String>.from(map['variety'] ?? {}),
      price: map['price'] ?? 0.0,
      isBookmarked: map['isBookmarked'] ?? false,
    );
  }

  // Method to convert CropPrice instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'unit': unit,
      'unitShort': unitShort,
      'variety': variety,
      'price': price,
      'isBookmarked': isBookmarked,
    };
  }
}

