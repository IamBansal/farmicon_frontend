// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'address.freezed.dart';
//
// @freezed
// class Address with _$Address {
//   factory Address({
//     required String streetName,
//     required String city,
//     required String district,
//     required int pincode,
//   }) = _Address;
// }


class Address {
  String streetName;
  String city;
  String district;
  int pincode;

  // Constructor
  Address({
    required this.streetName,
    required this.city,
    required this.district,
    required this.pincode,
  });

  // Factory method to create an Address instance from a Map
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      streetName: map['streetName'],
      city: map['city'],
      district: map['district'],
      pincode: map['pincode'],
    );
  }

  // Method to convert Address instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'streetName': streetName,
      'city': city,
      'district': district,
      'pincode': pincode,
    };
  }
}
